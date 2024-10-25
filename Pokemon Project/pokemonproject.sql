/* Data Analytics Project: pokemon_bw database */

USE pokemon_bw;

/* Data Retrieval Skills: SELECT, JOIN, Filtering and Sorting */
-- seeing basic information about pokemon --> try to find a way to combine types
SELECT p.PokedexNum, p.PokemonName, t.TypeName, a.AbilityName, a.Description AS AbilityDescription
FROM pokemon AS p
JOIN pokemonability AS pa ON pa.PokemonID = p.PokemonID
JOIN ability AS a ON a.AbilityID = pa.AbilityID
JOIN pokemontype AS pt ON pt.PokemonID = p.PokemonID
JOIN type AS t ON t.TypeID = pt.TypeID
ORDER BY p.PokemonID ASC;

-- seeing basic information about items --> item2typeid issue, maybe use left join or outer join or smth
SELECT i.ItemName, l.LocationName, i.Item1TypeID, i.Item2TypeID
FROM location AS l
JOIN itemlocation AS il ON il.LocationID = l.LocationID
JOIN item AS i ON i.ItemID = il.ItemID
JOIN itemtype AS it ON it.ItemTypeID = i.Item1TypeID
ORDER BY i.ItemID ASC;

-- seeing basic information about gyms
SELECT g.GymName, t.TypeName, mt.MainTrainerName, l.LocationName, g.GymBadgeName, tm.TMName, g.Effects
FROM gym AS g
JOIN type AS t ON t.TypeID = g.TypeID
JOIN maintrainers AS mt ON mt.MainTrainerID = g.LeaderID
JOIN location AS l ON l.LocationID = g.LocationID
JOIN tm ON tm.TMID = g.TMRewardID
ORDER BY g.GymID ASC;

-- seeing basic information about gym leaders --> collate the trainer held items and the 
-- SELECT g.GymName, mt.MainTrainerName, t.TypeName, mtt.Reward, mtt.Item1ID, mtt.Item2ID, mtt.Item3ID, mtt.Item4ID
SELECT g.GymName, mt.MainTrainerName, t.TypeName, mtt.Reward, mtt.Item1ID, mtt.Item2ID
FROM gym AS g
JOIN 
-- seeing basic information about trainers


/* Data Transformation and Manipulation: Aggregate Functions, CASE Statements, Window Functions */

-- aggregating grass type pokemon found in pinwheel forest
-- aggregating bug type pokemon found in pinwheel forest
-- comparing the counts of bug and grass type pokemon found in pinwheel forest
-- calculations using type matchups
-- window functions

/* Subqueries and Nested Queries and Correlated Subqueries */


/* Indexing and Optimization */


/* Stored Procedures */


/* Pokemon Specific Queries */