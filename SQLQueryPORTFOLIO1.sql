select *
from portfolioproject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4



--looking at counties with highest death rate per population

select location,  MAX(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..CovidDeaths
where continent is not null
Group by location
order by totaldeathcount desc

--By Continent
select continent,  MAX(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..CovidDeaths
where continent is not null
Group by continent
order by totaldeathcount desc


--looking at counties in Africa with highest death rate compared to population

select location, population, MAX(total_deaths) as highestdeathcount, MAX((total_deaths/population))*100 as
percentpopulationdeath
from portfolioproject..CovidDeaths
Where continent like '%africa%'
Group by location, population
order by percentpopulationdeath desc


--looking at countries with highest infection rate compared to population

select location, population, MAX(total_cases) as highestinfectioncount, MAX((total_cases/population))*100 as
percentpopulationinfected
from portfolioproject..CovidDeaths
where continent is not null
Group by location, population
order by percentpopulationinfected desc

--GLOBAL NUMBERS

Select date, SUM(new_cases)as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group by date
Order by 1,2

Select SUM(new_cases)as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Order by 1,2


--looking at total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date)
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3
