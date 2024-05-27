# Load necessary libraries
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(stargazer)
library(car)

### Combine datasets, clean data, and run regressions ###

# Part 1: Data Manipulating (Cleaning)

# Dataset 1: Financial self-sufficiency rate
fin <- read_excel("C:/Users/ASUS/Desktop/BJTU/毕业论文/城投混改数据/【12】财政自给率1.xlsx")

# Turn data from wide to long format and separate columns
fin_long <- fin %>%
  pivot_longer(-指标名称, names_to = "variable") %>%
  separate(variable, into = c("variable", "c"), sep = ":") %>%
  separate(指标名称, into = c("年份", "d"), sep = "-")

# Filtered the financial self-sufficiency rate data
fin_cleaned <- fin_long %>%
  select(省份 = variable, 年份, 财政自给率 = c)

# Write the cleaned data to CSV
write.csv(fin_cleaned, "【12】财政自给率-格式转化.csv")

# Dataset 2: Local government debt balance
debt_data_path <- "C:/Users/ASUS/Desktop/BJTU/毕业论文/城投混改数据/114 2021-2006年地方债务余额/地级市/城市地方债务余额2006-2021年"
years <- 2006:2020

debt_data <- bind_rows(lapply(years, function(year) {
  file_path <- paste0(debt_data_path, "/地方债务余额统计(", year, "1231).xls")
  data <- read_excel(file_path)
  data$Year <- year
  data
}))

write.csv(debt_data, "城投债余额统计-汇总-2006-2020.csv")

# Part 2: Read and Clean Final Dataset

# Read the final dataset
data <- read_excel("【final】回归一数据-城投加公司债.xlsx", skip = 1)

# Remove unwanted columns
data_cleaned <- data %>%
  select(-ID, -Name) %>%
  na.omit()

# Clean column names by removing extra spaces and special characters
colnames(data_cleaned) <- colnames(data_cleaned) %>%
  str_replace_all("[[:space:]]+", "_") %>%
  str_replace_all("[^[:alnum:]_]", "")

# Convert character columns to appropriate data types if necessary
data_cleaned <- data_cleaned %>%
  mutate(
    Year = as.numeric(Year),
    Private = as.factor(Private)
  )
remove_outliers <- function(df, column) {
  Q05 <- quantile(df[[column]], 0.05)
  Q95 <- quantile(df[[column]], 0.95)
  df %>%
    filter(df[[column]] >= Q05 & df[[column]] <= Q95)
}

# Apply outlier removal to dependent var
data_final <- remove_outliers(data_final, "Spread") 

# Merge with financial self-sufficiency rate data
data_merged <- data_cleaned %>%
  left_join(fin_cleaned, by = c("省份", "Year" = "年份"))

# Merge with debt balance data
data_final <- data_merged %>%
  left_join(debt_cleaned, by = c("省份", "Year"))

# Create a separate dataset for correlation analysis by excluding 'Year'
data_cor <- data_final %>%
  select(-Year) %>%
  na.omit()

# Convert to data frame for compatibility with base R functions
data_final <- as.data.frame(data_final)
data_cor <- as.data.frame(data_cor)

# Descriptive statistics
stargazer(data_final, type = "text", out = "DescriptiveAnalysis.txt")

# Separate data into mixed and non-mixed companies for further analysis
data_mixed <- filter(data_final, Private == 1)
data_non_mixed <- filter(data_final, Private == 0)

# Save descriptive statistics for mixed and non-mixed companies
stargazer(data_mixed, type = "text", out = "描述性统计-加rating-已混改企业.txt")
stargazer(data_non_mixed, type = "text", out = "描述性统计-加rating-未混改企业.txt")

# Correlation analysis and save to CSV
cor_data <- cor(data_cor)
write.csv(cor_data, "regression-cor.csv")

# Aggregate spread by Rating and Private/Type and print results
spread_by_rating_private <- aggregate(data_final$Spread, by = list(data_final$Rating, data_final$Private), FUN = length)
print(spread_by_rating_private)

spread_by_rating_type <- aggregate(data_final$Spread, by = list(data_final$Rating, data_final$Type), FUN = length)
print(spread_by_rating_type)

# Part 3: Regression Analysis

# Regression analysis without interaction effects
lm1 <- lm(Spread ~ Type + Maturity + Volume + Explicit + Special + Rating + Rating1 + Grade + Area + List + Asset + Leverage + Collateral + ROA + Turnover + Year, data = data_final)

# Regression analysis with interaction effects
lm2 <- lm(Spread ~ Type + I(Private * Type) + Maturity + Volume + Explicit + Special + Rating + Rating1 + Grade + Area + List + Asset + Leverage + Collateral + ROA + Turnover + Year, data = data_final)

# Save regression results
stargazer(lm1, lm2, type = "text", column.labels = c("模型1：无交互效应", "模型2：含交互效应"), out = "回归结果-加rating-回归1.txt")

# Regression analysis for mixed companies
lma1 <- lm(Spread ~ Private + LFS1 + Maturity + Volume + Explicit + Special + Rating + Rating1 + Grade + Area + Asset + Leverage + ROA + Turnover + Year, data = data_mixed)
lma2 <- lm(Spread ~ Private + LFS1 + I(Private * LFS1) + Maturity + Volume + Explicit + Special + Rating + Rating1 + Grade + Area + Asset + Leverage + ROA + Turnover + Year, data = data_mixed)
lma3 <- lm(Spread ~ Private + LFS2 + I(Private * LFS2) + Maturity + Volume + Explicit + Special + Rating + Grade + Area + List + Asset + Leverage + Collateral + ROA + Turnover + Year, data = data_mixed)
lma4 <- lm(Spread ~ Private + LFS3 + I(Private * LFS3) + Maturity + Volume + Explicit + Special + Rating + Grade + Area + List + Asset + Leverage + Collateral + ROA + Turnover + Year, data = data_mixed)

# Save regression results for mixed companies
stargazer(lma1, lma2, lma3, lma4, type = "text", out = "regressionresult2year.txt")

# Variance Inflation Factor (VIF) check
vif(lma2)

# Save all regression results to file
stargazer(lma1, lma2, lma3, lma4, type = "text", out = "regressionresult2year.txt")
