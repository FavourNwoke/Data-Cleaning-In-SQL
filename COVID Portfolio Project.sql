select *
from portfolioproject..CovidDeaths
where continent is not null
order by 3,4

select *
from PortfolioProject..CovidVaccinations
order by 3,4



--looking at counties with the highest death rate per population

select location,  MAX(cast(total_deaths as int)) as totaldeathcount
from portfolioproject..CovidDeaths
where continent is not null
Group by location
order by totaldeathcount desc

--continent with the highest death rate per population

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


--USE CTE

With PopvsVac (continent, location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


--TEMP TABLE

Create Table #PercentPopulationVaccination
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccination


--creating view to store date to visualize later

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(INT,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	--order by 2,3


Select *
From PercentPopulationVaccinated
