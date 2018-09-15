# Prep environment
library(tidyverse)
library(gridExtra)

# Load and prep data
loans <- read.csv('prosperLoanData.csv')
loans$LoanOriginationQuarter <- factor(loans$LoanOriginationQuarter,
                                       levels = c("Q4 2005", "Q1 2006", "Q2 2006", "Q3 2006", "Q4 2006", "Q1 2007", "Q2 2007", "Q3 2007", "Q4 2007", "Q1 2008", "Q2 2008", "Q3 2008", "Q4 2008", "Q1 2009", "Q2 2009", "Q3 2009", "Q4 2009", "Q1 2010", "Q2 2010", "Q3 2010", "Q4 2010", "Q1 2011", "Q2 2011", "Q3 2011", "Q4 2011", "Q1 2012", "Q2 2012", "Q3 2012", "Q4 2012", "Q1 2013", "Q2 2013", "Q3 2013", "Q4 2013"))
loans$IncomeRange <- factor(loans$IncomeRange,
                            levels = c("Not displayed","Not employed","$0","$1-24,999",
                                       "$25,000-49,999","$50,000-74,999",
                                       "$75,000-99,999","$100,000+"))
# Test for bad loans:
is_bad_loan <- function(status) {
  ifelse(test = status %in% c('Chargedoff','Defaulted') |
           grepl('Past Due', status),
         yes = TRUE,
         no = FALSE)
}

loans$IsBadLoan <- is_bad_loan(loans$LoanStatus)

#### EXPORT FINAL DATA FOR VIZ ####
loans_export <- loans %>%
  filter(!is.na(ProsperScore)) %>%
  select(ProsperScore, BorrowerRate, IsBadLoan) %>%
  group_by(ProsperScore) %>%
  mutate(MeanRatePerScore = mean(BorrowerRate),
         NumPerScore = n()) %>%
  filter(IsBadLoan) %>%
  group_by(ProsperScore) %>%
  mutate(PropBadPerScore = n()/NumPerScore) %>%
  select(ProsperScore, MeanRatePerScore, PropBadPerScore) %>%
  distinct()
  
write.csv(loans_export, 'prosper_loans_export.csv')
####


# Select loans starting August 2009:
loans_on_after_Q3_2009 <- subset(loans, LoanOriginationQuarter %in% c("Q3 2009", "Q4 2009", "Q1 2010", "Q2 2010", "Q3 2010", "Q4 2010", "Q1 2011", "Q2 2011", "Q3 2011", "Q4 2011", "Q1 2012", "Q2 2012", "Q3 2012", "Q4 2012", "Q1 2013", "Q2 2013", "Q3 2013", "Q4 2013"))

ggplot(data = loans,
       aes(x = ProsperScore)) +
  geom_histogram(bins = 10)

ggplot(data = loans,
       aes(x = LoanStatus)) +
  geom_bar()

# Interest Rate vs. Prosper Score
ggplot(data = loans,
       aes(x = ProsperScore)) +
  # geom_bar(aes(y = BorrowerRate, fill = IsBadLoan),
  geom_bar(aes(y = BorrowerRate, fill = 'red'),
           stat = 'summary',
           fun.y = mean,
           position = 'dodge') +
  scale_x_continuous(name = 'Prosper Score',
                     breaks = c(1:11)) +
  scale_y_continuous(name = 'Mean Interest Rate') +
  ggtitle('Interest Rate vs. Prosper Score')

# Number of Bad Loans per Prosper Score
ggplot(data = loans,
       aes(x = ProsperScore, fill = IsBadLoan)) +
  geom_bar() +
  scale_x_continuous(name = 'Prosper Score',
                     breaks = c(1:11)) +
  scale_y_continuous(name = 'Number of Loans') +
  ggtitle('Number of Loans per Prosper Score')

# Proportion of Bad Loans per Prosper Score
ggplot(data = loans,
       aes(x = ProsperScore, fill = IsBadLoan)) +
  geom_bar(position = 'fill') +
  scale_x_continuous(name = 'Prosper Score',
                     breaks = c(1:11)) +
  scale_y_continuous(name = 'Proportion of Loans') +
  coord_cartesian(ylim = c(0, 0.4)) +
  ggtitle('Proportion of Bad Loans per Prosper Score')
######

#### Mean Prosper Score for bad loans ####
# Find bad loans
bad_loans <- loans %>%
  filter(is_bad_loan(LoanStatus))

ggplot(data = bad_loans,
       aes(x = ProsperScore)) +
  geom_histogram(bins = 11)
  # scale_x_continuous(name = 'Prosper Score',
  #                    breaks = c(1:11)) +
  # scale_y_continuous(name = 'Mean Interest Rate') +
  # ggtitle('Interest Rate vs. Prosper Score')
######


#### Number of Loans per Income Range ####
ggplot(data = loans,
       aes(x = IncomeRange)) +
  geom_bar() +
  scale_x_discrete() +
  scale_y_continuous(name = 'Number of Loans')
#####

#### Number of BAD Loans per Income Range ####
ggplot(data = loans,
       aes(x = IncomeRange, fill = IsBadLoan)) +
  geom_bar() +
  scale_x_discrete() +
  scale_y_continuous(name = 'Number of Loans') +
  ggtitle('Proportion of Bad Loans in each Income Range')
#####

# Bad Loans per Income Range
ggplot(data = subset(loans, IsBadLoan),
       aes(x = IncomeRange)) +
  geom_bar() +
  scale_x_discrete() +
  scale_y_continuous(name = 'Number of Bad Loans')

# Proportion of Bad Loans in each Income Range
proportion_bad_per_income <- loans %>%
  group_by(IncomeRange, IsBadLoan) %>%
  summarise(n_per_income_per_status = n()) %>%
  group_by(IncomeRange) %>%
  mutate(n_per_income = sum(n_per_income_per_status)) %>%
  mutate(prop = n_per_income_per_status/sum(n_per_income_per_status)) %>%
  filter(IsBadLoan == TRUE)
ggplot(data = proportion_bad_per_income,
       aes(x = IncomeRange, y = prop)) +
  geom_col() +
  scale_x_discrete(name = 'Income Range') +
  scale_y_continuous(name = 'Proportion of Defaulted Loans') +
  ggtitle('Proportion of Bad Loans in each Income Range')

# Mean Borrower Rate per Income Range
mean_rate_per_income <- loans %>%
  group_by(IncomeRange) %>%
  summarise(mean_rate = mean(BorrowerRate))
ggplot(data = mean_rate_per_income,
       aes(x = IncomeRange, y = mean_rate)) +
  geom_col() +
  scale_x_discrete() +
  scale_y_continuous(name = 'Mean Interest Rate') +
  ggtitle('Mean Borrower Rate per Income Range')

# Mean Borrower Rate per Income Range ON BAD LOANS
mean_rate_per_income_on_bad <- loans %>%
  filter(IsBadLoan) %>%
  group_by(IncomeRange) %>%
  summarise(mean_rate = mean(BorrowerRate))
ggplot(data = mean_rate_per_income_on_bad,
       aes(x = IncomeRange, y = mean_rate)) +
  geom_col() +
  scale_x_discrete() +
  scale_y_continuous(name = 'Mean Interest Rate') +
  ggtitle('Mean Borrower Rate per Income Range on Bad Loans')

# Mean Borrower Rate on Good vs. Bad Loans
mean_rate_per_income_on_both <- loans %>%
  group_by(IsBadLoan, IncomeRange) %>%
  summarise(mean_rate = mean(BorrowerRate))
ggplot(data = loans,
       aes(x = IncomeRange)) +
  geom_bar(aes(y = BorrowerRate, fill = IsBadLoan),
               stat = 'summary',
               fun.y = mean,
               position = 'dodge') +
  scale_x_discrete() +
  scale_y_continuous(name = 'Mean Interest Rate') +
  ggtitle('Mean Borrower Rate per Income Range')

#### FROM Q3 2009, SO WE CAN USE PROSPER SCORE: ####
proportion_defaulted_per_income <- loans_on_after_Q3_2009 %>%
  group_by(IncomeRange, LoanStatus) %>%
  summarise(n_per_income_per_status = n()) %>%
  group_by(IncomeRange) %>%
  mutate(n_per_income = sum(n_per_income_per_status)) %>%
  mutate(prop = n_per_income_per_status/sum(n_per_income_per_status)) %>%
  filter(LoanStatus == 'Defaulted')
ggplot(data = proportion_defaulted_per_income,
       aes(x = IncomeRange, y = prop)) +
  geom_col() +
  scale_x_discrete(name = 'Income Range') +
  scale_y_continuous(name = 'Proportion of Defaulted Loans')

# Mean Borrower Rate per Income Range
mean_rate_per_income <- loans_on_after_Q3_2009 %>%
  group_by(IncomeRange) %>%
  summarise(mean_rate = mean(BorrowerRate))
ggplot(data = mean_rate_per_income,
       aes(x = IncomeRange, y = mean_rate)) +
  geom_col() +
  scale_x_discrete() +
  scale_y_continuous(name = 'Mean Interest Rate')

# Mean Prosper Score per Income Range
mean_score_per_income <- subset(loans_on_after_Q3_2009, !is.na(ProsperScore)) %>%
  group_by(IncomeRange) %>%
  summarise(mean_score = mean(ProsperScore))
ggplot(data = mean_score_per_income,
       aes(x = IncomeRange, y = mean_score)) +
  geom_col() +
  scale_x_discrete() +
  scale_y_continuous(name = 'Mean Prosper Score')


ggplot(data = loans,
       aes(x = LoanOriginalAmount)) +
  geom_histogram()


ggplot(data = subset(loans, LoanStatus == 'Defaulted'),
       aes(x = LoanOriginalAmount)) +
  geom_histogram(binwidth = 5000) +
  scale_y_continuous(name = 'Number of Defaulted Loans')


# Line chart: Quarter the loan was originated
quarter_count <- loans %>%
                  count(LoanOriginationQuarter)
ggplot(data = quarter_count,
       aes(x = LoanOriginationQuarter, y = n)) +
  geom_line(aes(group = 1)) +
  geom_point() +
  scale_x_discrete(breaks = c("Q4 2005", "Q4 2006", "Q4 2007", "Q4 2008","Q4 2009", "Q4 2010","Q4 2011","Q4 2012","Q4 2013"))


# Line chart: Quarter the loan was defaulted in
loans_defaulted_closed_date <- subset(loans,
                                      LoanStatus == 'Defaulted' & !is.na(ClosedDate))
loans_defaulted_closed_date$ClosedDate_DateObj <- ymd_hms(loans_defaulted_closed_date$ClosedDate,
                                                          tz = 'UTC')
loans_defaulted_closed_date$ClosedQuarter <- sprintf('Q%s %s',
                                                     quarter(loans_defaulted_closed_date$ClosedDate_DateObj),
                                                     year(loans_defaulted_closed_date$ClosedDate_DateObj))
loans_defaulted_closed_date$ClosedQuarter <- factor(loans_defaulted_closed_date$ClosedQuarter,
                                                    levels = c("Q4 2005", "Q1 2006", "Q2 2006", "Q3 2006", "Q4 2006", "Q1 2007", "Q2 2007", "Q3 2007", "Q4 2007", "Q1 2008", "Q2 2008", "Q3 2008", "Q4 2008", "Q1 2009", "Q2 2009", "Q3 2009", "Q4 2009", "Q1 2010", "Q2 2010", "Q3 2010", "Q4 2010", "Q1 2011", "Q2 2011", "Q3 2011", "Q4 2011", "Q1 2012", "Q2 2012", "Q3 2012", "Q4 2012", "Q1 2013", "Q2 2013", "Q3 2013", "Q4 2013"))

quarter_defaulted_count <- loans_defaulted_closed_date %>%
  group_by(Quarter = ClosedQuarter) %>%
  count()


ggplot(data = quarter_defaulted_count,
       aes(x = Quarter, y = n)) +
  geom_line(aes(group = 1)) +
  geom_point() +
  scale_x_discrete(breaks = c("Q4 2005", "Q4 2006", "Q4 2007", "Q4 2008","Q4 2009", "Q4 2010","Q4 2011","Q4 2012","Q4 2013"))


#### Trying out ggpairs ####
library(GGally)
ggpairs(loans,
        columns = c('Term','LoanStatus','BorrowerRate','ProsperScore',
                    'EmploymentStatus','DebtToIncomeRatio',
                    'IncomeRange','LoanOriginalAmount',
                    'Recommendations','Investors'))

#### Employment ####
ggplot(loans,
       aes(x = EmploymentStatus)) +
  geom_bar()
