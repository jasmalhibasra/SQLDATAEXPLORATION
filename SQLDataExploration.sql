Select * from covid_deaths order  by 3,4
--Select * from covid_vaccination order by 3,4

Select location,date, total_cases, new_cases, total_deaths, population
from covid_deaths
order by 1,2

--Looking for total cases vs total deaths
Select location,date, total_cases, total_deaths,CAST(total_deaths as float)/total_cases as Percentage
from covid_deaths where location like '%states%'
order by 1,2

--Looking for total cases vs population
Select location,date, total_cases,population,CAST(total_cases as float)/population*100 as Percentage
from covid_deaths 
--where location like '%states%'
order by 1,2

---looking at countries with highest infection rate compared to population
Select location,population, max(total_cases) as highestInfection,MAX(CAST(total_cases as float))/population*100 as InfectiousPercentage
from covid_deaths
group by location, population
order by InfectiousPercentage desc

Select location,max(total_deaths) as MAXDeaths
from covid_deaths
where continent is not null
group by Location
order by MAXDeaths desc

--break by continent with highest death count per population

Select continent,max(cast(total_deaths as int)) as TotalDeathCount
from covid_deaths
where continent is not null
group by continent
order by TotalDeathCount desc


Select  SUM(new_cases) as total_cases,
SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as float))/ SUM(new_cases)*100 as Death_percentage
from covid_deaths 
--where location like '%states%'
where continent is not null
--order by 1,2

--Total populations vs vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from covid_deaths dea
JOIN covid_vaccination vac
ON dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

WITH POPVAC(Continent, Location, Date, Population,new_vaccination,rolloingpeoplevaccination)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from covid_deaths dea
JOIN covid_vaccination vac
ON dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

)
Select *,(cast(rolloingpeoplevaccination as float)/Population)*100 from popvac


Create view pwercentpopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from covid_deaths dea
JOIN covid_vaccination vac
ON dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

Select * from pwercentpopulationvaccinated 
