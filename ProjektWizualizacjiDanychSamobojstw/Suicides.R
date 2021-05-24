Suicides<-read.csv("master.csv", header=TRUE)


colnames(Suicides)<-c("Country","Year","Sex","Age","Suicides_no","Population",
                      "Suicides/100k pop","Country-year","HDI for year", "Gdp_for_year ($)" ,"Gdp_per_capita ($)",
                      "Generation")
Suicides

View(colSums(is.na(Suicides))) #Sprawdzenie, ile razy dane w tabeli nie wystepuja dla danego atrybutu
print(sum(is.na(Suicides))) #Suma pustych komorek

IsEmpty<-colSums(is.na(Suicides)/nrow(Suicides))*100

View(IsEmpty,"EmptyDataPercentage")
#Zmienic nazwe koumny
lbls<-c("Empty","Not Empty")
#pustedane/niepuste
vec1<-c(sum(is.na(Suicides)),sum(!is.na(Suicides)))

pct<-round(vec1/sum(vec1)*100)
lbls<-paste(lbls,pct)
lbls <- paste(lbls,"%",sep="")
pie(vec1,labels=lbls, col=rainbow(length(lbls)), main="Empty Data Percentage")

UniqYears<-unique(Suicides[("Year")])
MinYear<-min(UniqYears) #Poczatkowy rok badn

MaxYear<-max(UniqYears)
MaxYear #Ostatni rok badan

SuicidesPointer<-Suicides[,c("Country","Suicides_no")]
SuicidesPointer

ResearchYears<-MaxYear-MinYear #Przedzial naszych badan (trwanie badan w latach)

UniqCountries<-unique(Suicides[("Country")]) #Mamy 101 unikalnych panstw
nrow(UniqCountries)

#Wykonanie interaktywnej mapy panstw, dla ktorych przeprowadzone zostaly statystyki

#usuwamy kolumne HDI
Suicides2<-within(Suicides, rm("HDI for year"))
Suicides2
#zapisujemy "oczyszczone" dane do pliku
saveRDS(Suicides2, file="SuicidesRmHDI.Rda")

#porownanie statystyk samobojstw wedlug plci - wykres kolowy
library(dplyr)

MaleSuicides<-Suicides2%>%
  filter(Sex=="male")%>%
  summarise(MaleSuicides=sum(Suicides_no))

FemaleSuicides<-Suicides2%>%
  filter(Sex=="female")%>%
  summarise(FemaleSuicides=sum(Suicides_no))

SuicidesSex<-data.frame(MaleSuicides,FemaleSuicides)
x <- c(SuicidesSex$MaleSuicides,SuicidesSex$FemaleSuicides)
labels <-  c("Male","Female")
piepercent<- round(100*x/sum(x), 1)

lbls<-c("Male","Female")
lbls<-paste(lbls,piepercent)
lbls <- paste(lbls,"%",sep="")

library(plotrix)
pie3D(x,labels = lbls,explode = 0.1, main = "Male and female pie of suicides")

#Krzywa liczby samobojstw w latach badan
library(ggplot2)

SuicidesSum<-Suicides2%>%
  group_by(Year)%>%
  summarise(sum(Suicides_no))

names(SuicidesSum)<-c("Year","Suicides_no")

ggplot(SuicidesSum, aes(Year,Suicides_no))+
  geom_line(color="#69b3a2",size=2,alpha=0.9)+
  xlim(1985,2015)+
  ggtitle("Krzywa samobojstw na przestrzeni lat badañ")+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"))+
  labs(x="Rok",y="Liczba samobójstw")

UniqAge<-unique(Suicides2[("Age")])

AgeSum<-Suicides2%>%
  group_by(Age)%>%
  summarise(sum(Suicides_no))

names(AgeSum)<-c("Age","Suicides_no")

library(forcats)
AgeSum$num = readr::parse_number(AgeSum$Age)
AgeSum[order(AgeSum$num),]

AgeSum%>%
  mutate(Age=fct_reorder(Age,num))%>%
  ggplot(aes(Age,Suicides_no))+
  geom_col(color="#330033",size=2,fill="#660033",width=0.7)+
  ggtitle("Liczba samobojstw dla poszczegolnych przedzialow wiekowych")+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"))+
  labs(x="Przedzial wiekowy",y="Liczba samobójstw")

library(hexbin)

GPD_Capita<-Suicides2%>%
  group_by(Country)%>%
  summarise(mean(`Gdp_per_capita ($)`))
names(GPD_Capita)<-c("Country","Capita")
 
GPD_100k<-Suicides2%>%
  group_by(Country)%>%
  summarise(mean(`Suicides/100k pop`))
names(GPD_100k)<-c("Country","Suicides")

bin<-hexbin( GPD_Capita$Capita,GPD_100k$Suicides, xbins=14)
plot(bin, main="Wykres heksagonalny wysokosci PKB na osobe i 
     wspólczynnika samobójstw na 100k mieszkañców", xlab="PBK na mieszkañca ($)",
     ylab="Liczba samobójstw na 100k mieszkañców")


library(ggcorrplot)


Suicides2$`Gdp_for_year ($)`<-as.numeric(gsub(",","",Suicides2$`Gdp_for_year ($)`))
Suicides2<-within(Suicides2, rm("Country-year"))

corr<-cor(Suicides2[,5:8])
ggcorrplot(corr, method='circle', type='lower', lab=TRUE)

bin<-hexbin( GPD_Capita$Capita,GPD_100k$Suicides, xbins=14)
plot(bin, main="Wykres heksagonalny wysokosci PKB na osobe i 
     wspólczynnika samobójstw na 100k mieszkañców", xlab="PBK na mieszkañca ($)",
     ylab="Liczba samobójstw na 100k mieszkañców")

UniqGens<-unique(Suicides2[("Generation")])

library(fmsb)
Max<-Suicides2%>%
  group_by(Generation)%>%
  summarise(max(sum(Suicides_no)))

table<-data.frame(Max[,1],headers=TRUE)

table2<-c(Max[,1])
table2
table3<-c(Max[,2])
table3


library(data.table)

dfdft<-transpose(dfdf)
dfdft


sums <- data.frame(
  row.names = c("Sums"),
  `Boomers G.I.` = c(2284498),
  Generation = c(510009),
  `Generation X` = c(1532804),
  `Generation Z` = c(15906),
  Millenials = c(623459),
  Silent = c(1781744)
)
sums

max_min <- data.frame(
  `Boomers G.I.` = c(2500000, 0), Generation = c(2500000, 0), `Generation X` = c(2500000, 0),
  `Generation Z` = c(2500000, 0), Millenials = c(2500000, 0), Silent = c(2500000, 0)
)
rownames(max_min) <- c("Max", "Min")
df2<-rbind(max_min,sums)
df2

sums1 <- df2[c("Max", "Min", "Sums"), ]
radarchart(sums1)

create_beautiful_radarchart <- function(data, color = "#00AFBB", 
                                       vlabels = colnames(data), vlcex = 0.7,
                                       caxislabels = NULL, title = NULL, ...){
  radarchart(
    data, axistype = 1,
    # Customize the polygon
    pcol = color, pfcol = scales::alpha(color, 0.5), plwd = 2, plty = 1,
    # Customize the grid
    cglcol = "blue", cglty = 1, cglwd = 0.8,
    # Customize the axis
    axislabcol = "orange", 
    # Variable labels
    vlcex = vlcex, vlabels = vlabels,
    caxislabels = caxislabels, title = title, ...
  )
}

op <- par(mar = c(1, 2, 2, 1))
create_beautiful_radarchart(sums1, caxislabels = c(0, 500000, 1000000, 1500000, 2000000, 2500000))
par(op)


Mean<-Suicides2%>%
  group_by(Country)%>%
  summarise(mean(`Suicides/100k pop`))
names(Mean)<-c("Country","Suicides/100k pop")


CountrySuicides100k <- ggplot(Mean, aes(Country, `Suicides/100k pop`))+ 
  geom_point()+ theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust=0.8))+ 
  geom_point(color = "steelblue")+
  ggtitle("Wykres wspolczynnika samobojstw/100k od panstw.")+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"))+
  labs(x="Panstwa",y="Wspolczynnik samobojstw/100k")
CountrySuicides100k

Top5<-Mean%>% 
  top_n(5)
Top5

Min5<-Mean%>% 
  top_n(-7)
Min5

  ggplot(Top5, aes(Country,`Suicides/100k pop`))+
  geom_col(color="black",size=1.8,fill="#6633FF",width=0.7)+
  ggtitle("5 panstw z najwyzszym wspolczynnikiem samobojstw na 100k mieszkancow")+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"))+
  labs(x="Panstwa",y="Wspolczynnik samobojstw na 100k mieszkancow")
  
  
  