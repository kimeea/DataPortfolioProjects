SELECT * 
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4;

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract convid in your country (rough estimates)
SELECT Location, date, total_cases, total_deaths, (CONVERT(FLOAT, CONVERT(FLOAT, total_deaths))/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2;

-- Looking at Total Cases vs Total Deaths in the United States
-- ---------------------------------------FIX CONVERT---------------------------------------------------------------------
SELECT Location, date, total_cases, total_deaths, (CONVERT(FLOAT, CONVERT(FLOAT, total_deaths))/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2;

-- Looking at Total Cases vs Population in the United States
-- Shows what percentage of population got Covid
SELECT Location, date, Population, total_cases, (CONVERT(FLOAT,total_cases)/CONVERT(FLOAT, population)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE Location like '%states%'
ORDER BY 1,2;

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX(CONVERT(FLOAT,total_cases)/CONVERT(FLOAT,population)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Showing Countries with Highest Death Count per Population
SELECT Location, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Let's break things down by continent
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC; 

-- Getting ready for visualizations --
-- Global Numbers --

-- Death percentage across the world
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(CAST(new_deaths AS FLOAT))/SUM(CAST(new_cases AS FLOAT))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Join 
SELECT *
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date;

-- Looking at total population vs. vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
order by 2,3;

-- Using a CTE to complete the query above
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *
FROM PopvsVac;

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population) * 100
FROM PopvsVac;


-- Temp Table

--DROP TABLE IF EXISTS #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *, (RollingPeopleVAccinated/Population) * 100
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT * 
FROM PercentPopulationVaccinated;