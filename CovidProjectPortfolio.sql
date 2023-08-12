Select *
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--Order by 3,4

--Select the data that we are going to use

Select Location, date, total_cases, new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--Looking at Total cases vs Total Deaths
--Shows likelihood of dying if you contact covid in your country

Select Location, date, total_cases, total_deaths,CONVERT(decimal(15,3), total_deaths/ CONVERT(Decimal(15,3),total_cases))*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where Location = 'Lesotho' AND continent is not null
Order by 1,2

-- Looking at the Total cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, total_cases, population,CONVERT(decimal(15,3), total_cases/ CONVERT(Decimal(15,3),population))*100 AS InfectionRate
From PortfolioProject..CovidDeaths
--Where Location = 'Lesotho'
Order by 1,2

--Looking at Countries with Highest Infection Rate compared to Population
Select Location,population, MAX( total_cases) HighestInfectionCount, MAX(CONVERT(decimal(15,3), total_cases/ CONVERT(Decimal(15,3),population))*100 ) AS PerntagePopulationInfected
From PortfolioProject..CovidDeaths
--Where Location = 'Lesotho'
Group By Location,Population
Order by PerntagePopulationInfected Desc

--Showing Countries with Highest Death Count per Population

Select Location, MAX( Cast(total_deaths as Int)) AS TotalDeathCount
From PortfolioProject..CovidDeaths
--Where Location = 'Lesotho'
Where continent is not null
Group By Location
Order by TotalDeathCount Desc


--LET'S BREAK THINGS DOWN BY CONTINENT

--Showing Continent with the Highest Death Count

Select continent, MAX( Cast(total_deaths as Int)) AS TotalDeathCount
From PortfolioProject..CovidDeaths
--Where Location = 'Lesotho'
Where continent is not null
Group By  continent
Order by TotalDeathCount Desc



-- GLOBAL NUMBERS
-- Showing the global mortality rate

Select  SUM(new_cases) Total_cases,SUM(Cast(new_deaths as int)) Total_deaths,SUM(Cast(new_deaths as int))/SUM(New_cases) * 100  AS DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null 
--Group by date
Order by 1,2

-- Looking at total population vs vaccinations
--select *
--From PortfolioProject..CovidVaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) As RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--USE CTE
With PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) As RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


--USE TEMP TABLE
DROP Table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime ,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentagePopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) As RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
Select *
From #PercentagePopulationVaccinated


--Create Views for later visualizations

Create View PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) As RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
