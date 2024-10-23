-- Covid Vaccinations data
SELECT * 
FROM PortfolioProject..CovidVaccinations
ORDER BY location, date;

-- key columns from Covid Deaths table
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY location, date;

-- Looking at Total Cases vs Total Deaths 
-- Calculating death percentage
-- Shows likelihood of dying if you contract convid in your country (rough estimates)
-- CONVERT(FLOAT, total_deaths) converts the total deaths to a floating-point number to avoid integer division
SELECT Location, date, total_cases, total_deaths, (CONVERT(FLOAT, CONVERT(FLOAT, total_deaths))/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY location, date;

-- Looking at Total Cases vs Total Deaths in the United States
-----------------------------------------FIX CONVERT---------------------------------------------------------------------
--Filter for US
SELECT Location, date, total_cases, total_deaths, (CONVERT(FLOAT, CONVERT(FLOAT, total_deaths))/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
ORDER BY location, date;

-- Looking at Total Cases vs Population in the United States
-- Shows what percentage of population got Covid in the United States
SELECT Location, date, Population, total_cases, (CONVERT(FLOAT,total_cases)/CONVERT(FLOAT, population)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE Location like '%states%'
ORDER BY location, date;

-- Looking at Countries with Highest Infection Rate compared to Population
-- Group the data by location and calculate the highest infection count and percentage of the 
-- population infected
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX(CONVERT(FLOAT,total_cases)/CONVERT(FLOAT,population)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- Showing Countries with Highest Death Count per Population
-- Group countries and find the maximum death count
-- Exclude locations where the continent is NULL
SELECT Location, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Countries with the highest death count by continent
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Let's break things down by continent
-- shows highest death count by continent
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC; 

-- Getting ready for visualizations --
-- Global Numbers --

-- Death percentage across the world (global death percentage)
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(CAST(new_deaths AS FLOAT))/SUM(CAST(new_cases AS FLOAT))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY total_cases, total_deaths;

-- Join the two tables by location and date
SELECT *
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date;

-- Looking at total population vs. vaccinations
-- using a rolling sum of vaccinations for each location (window function)
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, 
dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
order by dea.location, dea.date;

-- Using a CTE to complete the query above (rolling vaccinations)
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

-- CTE for rolling vaccinations and percentage of people vaccinated
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


-- Temp Table to store population vaccination data and calculate the percentage vaccinated
-- use the temporary table for percent population vaccinated

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

-- insert data into the temporary table
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
-- store and retrieve population vaccination data for future use
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