select * 
from Portfolio_Project..covid_Deaths

Select location, date, total_cases, total_deaths, new_cases, population
From Portfolio_Project..covid_Deaths
Where location= 'Tonga'

--total cases vs population
select continent, location, total_cases, population, (total_cases/population)*100 as death_percent
from Portfolio_Project..covid_Deaths
Where location like '%states%'
order by 1,2

--Highest infection rate
Select location, population, MAX(total_cases) as Highest_infection_rate,
MAX(total_cases/population)*100 as percent_population
From Portfolio_Project..covid_Deaths
Group by location, population
Order by 1,2


--Highest death counts
Select location, population, MAX(CAST(total_deaths as int)) as Highest_death_count
from Portfolio_Project..covid_Deaths
Group by location, population
Order by Highest_death_count DESC


Select location, MAX(CAST(total_deaths as int)) as Highest_death_count
from Portfolio_Project..covid_Deaths
where  continent is not null
Group by location
Order by Highest_death_count DESC



--Globel numbers

Select date, SUM(CAST(new_cases as float)), SUM(CAST(new_deaths as float))
,SUM(CAST(new_deaths as float))/SUM(CAST(new_cases as float))*100 as DeathPercent
--,SUM(new_deaths)/SUM(new_cases)*100 as Deathpercent
From Portfolio_Project..covid_Deaths
where continent is not null 
group by date
order by 1,2


 
 Select * 
 From Portfolio_Project..covid_Deaths dea
 join Portfolio_Project..covid_vaccination vac
 on dea.location = vac.location
 and dea.date = vac.date
 
 ---CTE
with PopvsVac(continent, location,date, population,new_vaccination,PeopleVaccinated)
as
(
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
 From Portfolio_Project..covid_Deaths dea
 join Portfolio_Project..covid_vaccination vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null 
 --order by 2,3
 )
 Select *, (PeopleVaccinated/population)*100 as Percentage
 from PopvsVac



----TEMP TABLE

 Create Table #Percentage
 (
 Continent nvarchar(255),
 location nvarchar(255),
 Date datetime,
 population numeric,
 new_vaccinations numeric,
 PeopleVaccinated numeric
 )

Insert into #Percentage
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
 From Portfolio_Project..covid_Deaths dea
 join Portfolio_Project..covid_vaccination vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null 
 --order by 2,3


  Select *, (PeopleVaccinated/population)*100 as Percentage
 from #Percentage


CREATE 
VIEW 
Percantage as

 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
 From Portfolio_Project..covid_Deaths dea
 join Portfolio_Project..covid_vaccination vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null 

 Select *
 From #Percentage