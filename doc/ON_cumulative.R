## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(data2019nCoV)
library(ggplot2)
library(tidyr)
library(dplyr)
library(scales)

daily_change <- function(series) {
  change <- c(series, NA) - c(NA, series)
  change <- change[-1]
  change <- change[-length(change)]
  return(change)
}

## ---- fig.width=6, fig.height=8-----------------------------------------------

#par(mfrow=c(3,1))


all_cases <- ( 
          c((ON_cumulative$ConfirmedPositive+ON_cumulative$Resolved+ON_cumulative$Deceased)[1:44],
                rep(0, length(ON_cumulative$Cases)-44))
              + c(rep(0, 44), ON_cumulative$Cases[45:length(ON_cumulative$Cases)])
              )

plot(ON_cumulative$LastUpdated, all_cases,
     main = "Cumulative Confirmed COVID-19 Cases in Ontario",
     xlab = "Date",
     ylab = "Cases (Open, Resolved, Deceased)",
     type = "b")

plot(ON_cumulative$LastUpdated[-1], daily_change(ON_cumulative$TotalTested), type="b",
     main = "Change in Total Tested Between Report",
     xlab = "Date",
     ylab = "Change in Total Tested Between Report")

colours <- c("red",   "blue",  "black", "magenta", "green")

matplot(ON_mohreports$date, cbind( 
                ( (ON_mohreports$deaths / ON_mohreports$cases) * 100 ),
                ( (ON_mohreports$severity_hospitalized / ON_mohreports$cases) * 100 ),
                ( (ON_mohreports$severity_icu / ON_mohreports$cases) * 100 ),
                ( (ON_mohreports$deaths_ltc_residents / ON_mohreports$cases_ltc_residents) * 100 ),
                ( (ON_mohreports$deaths_hospital_pts / ON_mohreports$cases_hospital_pts) * 100 )
               ),
                           
     main = "Ontario Severity and Outcomes",
     xlab = "Date (2020)",
     ylab = "Outcome (Percent)",
     type = "l",
     col = colours,
     lty = c("solid", "solid", "solid", "solid", "solid"),
     ylim = c(0,20),
     ylog = TRUE,
     xaxt="n")
dates<-format(ON_mohreports$date,"%b %d")
axis(1, at=ON_mohreports$date, labels=dates)
legend(x="top", 
       legend = c("CFR (Overall)", 
                  "Hospitalized (Cumulative)", 
                  "ICU (Cumulative)", 
                  "CFR (LTC Residents)",
                  "CFR (Hospital Outbreak Patients)"), 
       col = colours,
       lty = c("solid", "solid", "solid", "solid"), pch=18)

## ---- fig.width=6, fig.height=8-----------------------------------------------

ON_forplot <- rename(ON_mohreports,
    Ontario = cases, Toronto = cases_phu_toronto, Peel = cases_phu_peel, 
    York = cases_phu_york, Ottawa = cases_phu_ottawa, Durham = cases_phu_durham, 
    Waterloo = cases_phu_waterloo, Hamilton = cases_phu_hamilton, 
    Windsor... = cases_phu_windsoressex, Middlesex... = cases_phu_middlesexlondon, 
    Halton = cases_phu_halton, Niagara = cases_phu_niagara, 
    Simcoe... = cases_phu_simcoemuskoka, Haliburton... = cases_phu_haliburtonkawarthapineridge,
    Lambton = cases_phu_lambton, Wellington... = cases_phu_wellingtondufferinguelph, 
    Kingston... = cases_phu_kingstonfrontenaclennoxaddington, 
    Haldimand... = cases_phu_haldimandnorfolk, Peterborough = cases_phu_peterborough, 
    Leeds... = cases_phu_leedsgrenvillelanark, Brant = cases_phu_brant, 
    Eastern = cases_phu_easternontario, Porcupine = cases_phu_porcupine, 
    Sudbury = cases_phu_sudbury, Hastings... = cases_phu_hastingsprinceedward, 
    Grey... = cases_phu_greybruce, Southwestern = cases_phu_southwestern, 
    Chatham... = cases_phu_chathamkent, ThunderBay = cases_phu_thunderbay, 
    Renfrew = cases_phu_renfrew, Algoma = cases_phu_algoma, 
    HuronPerth = cases_phu_huronperth, NorthBay... = cases_phu_northbayparrysound, 
    Northwestern = cases_phu_northwestern, Timiskaming = cases_phu_timiskaming)


gather(ON_forplot, key, value, 
       Ontario, Toronto, Peel, York, Ottawa, Durham, Waterloo, Hamilton,
       Windsor..., Middlesex..., Halton, Niagara, Simcoe..., Haliburton...,
    Lambton, Wellington..., Kingston..., Haldimand..., Peterborough, 
    Leeds..., Brant, Eastern, Porcupine, Sudbury, Hastings..., 
    Grey..., Southwestern, Chatham..., ThunderBay, Renfrew, Algoma, 
    HuronPerth, NorthBay..., Northwestern, Timiskaming
       ) %>%
  ggplot(aes(x=date, y=value, col=key)) +
  geom_path() +
  #scale_y_continuous(trans = 'log10', labels = comma) +
  theme(legend.position="bottom") +
  labs(title = "Ontario COVID-19 Cases by Public Health Unit",
       x = "Date", 
       y = "Confirmed Cases") +
  guides(shape = guide_legend(override.aes = list(size = 0.5))) +
  guides(color = guide_legend(override.aes = list(size = 0.5))) +
  theme(legend.text = element_text(size = 7)) +
  theme(legend.title = element_blank())

gather(ON_mohreports, key, value, 
       cases,deaths,
       severity_hospitalized,severity_icu,
       cases_ltc_residents, cases_ltc_staff,
       cases_hospital_pts, deaths_hospital_pts,
       deaths_ltc_residents, cases_hcp
       ) %>%
  ggplot(aes(x=date, y=value, col=key)) +
  geom_line() +
  guides(shape = guide_legend(override.aes = list(size = 0.5))) +
  scale_y_continuous(trans = 'log10', labels = comma) +
  theme(legend.position="right") +
  labs(title = "Ontario COVID-19 Cases (Semilog.)",
       x = "Date", 
       y = "Confirmed Cases") +
  theme(legend.title = element_blank())

## ---- fig.width=6, fig.height=8-----------------------------------------------

par(mfrow=c(2,2))

plot(ON_mohreports$date[-1], daily_change(ON_mohreports$cases),
     main = "Daily new cases in Ontario",
     type = "b",
     xlab = "Date",
     ylab = "Daily new cases")

plot(ON_mohreports$date[-1], daily_change(ON_mohreports$deaths),
     main = "Daily new deaths in Ontario",
     type = "b",
     xlab = "Date",
     ylab = "Daily new deats")

plot(ON_mohreports$date[-1], daily_change(ON_mohreports$severity_hospitalized),
     main = "Daily new hospitalized cases in Ontario",
     type = "b",
     xlab = "Date",
     ylab = "Daily new hospitalized cases")

plot(ON_mohreports$date[-1], daily_change(ON_mohreports$severity_icu),
     main = "Daily new ICU cases in Ontario",
     type = "b",
     xlab = "Date",
     ylab = "Daily new ICU cases")



