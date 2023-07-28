select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- select * 
--from PortfolioProject..CovidVaccinations
--order by 1,2


--Select Data that we are going to be using
select location, date,total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2


--looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country
select location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths
where location like 'india'
order by 1,2


--looking at total cases bs population
select location, date, population, total_cases, (total_cases/population)*100 as case_percentage
from PortfolioProject..CovidDeaths
--where location like '%india%'
order by 1,2

--country which has the highest infection rate comapred to population
select location, population, MAX(total_cases) as totalCases, MAX((total_cases/population)*100) as percentageInfected
from PortfolioProject..CovidDeaths
--where location like '%india%'
group by location, population
order by percentageInfected desc


select location, MAX(cast(total_deaths as int)) as totalDeaths
from PortfolioProject..CovidDeaths
--where location like '%india%'
where continent is null
group by location
order by totalDeaths desc


-- break down things by continent
-- showing the continents with highest death counts
select continent, MAX(cast(total_deaths as int)) as totalDeaths
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by totalDeaths desc

-- global numbers
select SUM(new_cases) as totalCases,sum(cast(new_deaths as int)) as totalDeaths, 
    sum(cast(new_deaths as int))/SUM(new_cases)*100 as deathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

--************ CovidVaccinations **************

--join both tables
-- total population vs vaccinations

select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) as rolling_vacc_people
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
order by 2,3


---cte
with popVSvac (continent, location, date, population, new_vaccinations, rolling_vacc_people)
as
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) as rolling_vacc_people
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
-- order by 2,3
)
select *, (rolling_vacc_people/population)*100
from popVSvac


-- temp table
drop table if exists percentPopulationVaccinated
create table percentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_vacc_people numeric
)

insert into percentPopulationVaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) as rolling_vacc_people
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
-- order by 2,3
select *, (rolling_vacc_people/population)*100
from percentPopulationVaccinated



-- Creating view to store data for later visualizations

create view percentOfPopulationVaccinated as 
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) as rolling_vacc_people
from PortfolioProject..CovidDeaths cd
join PortfolioProject..CovidVaccinations cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
-- order by 2,3


select *
from percentOfPopulationVaccinated