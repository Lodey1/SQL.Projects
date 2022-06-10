SELECT * FROM coviddeaths
ORDER BY date;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM coviddeaths
WHERE new_deaths = "";
ALTER TABLE coviddeaths
MODIFY COLUMN new_deaths int;

DELETE FROM covidvaccinations
WHERE new_vaccinations = "";
ALTER TABLE covidvaccinations
MODIFY COLUMN new_vaccinations int;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
ORDER BY 1,2;

-- What countries have the highest infection rate?
SELECT location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100.0 as HighestInfectionRate
FROM coviddeaths
GROUP BY location, population
ORDER BY HighestInfectionRate;

-- What countries have the highest death rates
SELECT location, population, Max(total_deaths) as HighestDeathCount, Max((total_deaths/population)*100) as HighestDeathRate
FROM coviddeaths
GROUP BY location, population
ORDER BY HighestDeathCount DESC;

-- By continent
SELECT continent, SUM(total_deaths) AS TotalDeathCount
FROM coviddeaths
WHERE TRIM(continent) <> ""
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global NUmbers
SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage -- total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE TRIM(continent) <> ""
ORDER BY 1,2;

SELECT date, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage -- total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeaths
WHERE TRIM(continent) <> ""
GROUP BY date
ORDER BY 1,2;

SELECT * 
FROM covidvaccinations;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE TRIM(dea.continent) <> ""
ORDER BY 1,2,3;

CREATE TABLE PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population int,
NewVaccinations numeric
);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE TRIM(dea.continent) <> ""
ORDER BY 1,2,3;
 