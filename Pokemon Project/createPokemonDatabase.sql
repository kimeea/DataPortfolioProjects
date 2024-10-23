/* For this test, I'm going to create the skeleton structure of the tables and use 
the load data infile */
-- SUCCESSFUL TEST

CREATE DATABASE pokemon_bw;
USE pokemon_bw;

SHOW VARIABLES LIKE "secure_file_priv";
SELECT @@secure_file_priv;

-- 1. pokemon DONE
CREATE TABLE `pokemon` (
  `PokemonID` int PRIMARY KEY,
  `PokedexNum` int DEFAULT NULL,
  `PokemonName` text DEFAULT NULL,
  `HP` int DEFAULT NULL,
  `Atk` int DEFAULT NULL,
  `Def` int DEFAULT NULL,
  `SpA` int DEFAULT NULL,
  `SpD` int DEFAULT NULL,
  `Speed` int DEFAULT NULL,
  `Total` int DEFAULT NULL,
  `Mass_kG` int DEFAULT NULL,
  `mpercent` double DEFAULT NULL,
  `fpercent` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - Pokemon.csv'
INTO TABLE pokemon
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Use this if your CSV file has a header row to skip it

-- 2. type DONE
CREATE TABLE `type` (
  `TypeID` int PRIMARY KEY,
  `TypeName` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - Type.csv'
INTO TABLE type
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Use this if your CSV file has a header row to skip it

-- 3. ability DONE using TABLE DATA IMPORT WIZARD
CREATE TABLE `ability` (
  `AbilityID` int PRIMARY KEY,
  `AbilityName` text DEFAULT NULL,
  `Description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- this lead to error 1262
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - Sheet27.csv'
INTO TABLE ability
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Use this if your CSV file has a header row to skip it
DESCRIBE ability;


-- 4. trainertitle DONE
CREATE TABLE `trainertitle` (
  `TitleID` int PRIMARY KEY,
  `TrainerTitle` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - TrainerTitle.csv'
INTO TABLE trainertitle
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Use this if your CSV file has a header row to skip it


-- 5. itemtype DONE
CREATE TABLE `itemtype` (
  `ItemTypeID` int PRIMARY KEY,
  `ItemTypeName` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - ItemType.csv'
INTO TABLE itemtype
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Use this if your CSV file has a header row to skip it

-- 6. move DONE
CREATE TABLE `move` (
  `MoveID` int PRIMARY KEY,
  `MoveName` text DEFAULT NULL,
  `TypeID` int DEFAULT NULL,
  `MoveCategory` text DEFAULT NULL,
  `MovePP` int DEFAULT NULL,
  `MovePower` int DEFAULT NULL,
  `Accuracy` double DEFAULT NULL,
  `Gen` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- this lead to error 1366 --> does not work
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - Move.csv'
INTO TABLE move
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Use this if your CSV file has a header row to skip it

-- new file with NULL replacing empty values --> does not work
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Move.csv'
INTO TABLE move
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET MovePower = NULLIF(MovePower, 777);

-- new fix  ----> THIS WORKS
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - Move.csv'
INTO TABLE move
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET MovePower = NULLIF(MovePower, 777), Accuracy = NULLIF(Accuracy, 777);
SELECT * FROM move;


-- 7. location DONE
CREATE TABLE `location` (
  `LocationID` int PRIMARY KEY,
  `LocationName` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - Location.csv'
INTO TABLE location
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 8. pokemonlocation DONE
CREATE TABLE `pokemonlocation` (
  `PokemonLocationID` int PRIMARY KEY,
  `PokemonID` int DEFAULT NULL,
  `LocationID` int DEFAULT NULL,
  FOREIGN KEY (`PokemonID`) REFERENCES `pokemon`(`PokemonID`),
  FOREIGN KEY (`LocationID`) REFERENCES `location`(`LocationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - PokemonLocation.csv'
INTO TABLE pokemonlocation
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET LocationID = NULLIF (LocationID, 777);

-- 9. pokemontype DONE
CREATE TABLE `pokemontype` (
  `PokemonTypeID` INT PRIMARY KEY,
  `PokemonID` INT DEFAULT NULL,
  `TypeID` INT DEFAULT NULL,
  FOREIGN KEY (`TypeID`) REFERENCES `type`(`TypeID`),
  FOREIGN KEY (`PokemonID`) REFERENCES `pokemon`(`PokemonID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - PokemonType.csv'
INTO TABLE pokemontype
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 10. pokemonability DONE
CREATE TABLE `pokemonability` (
  `PokemonAbilityID` int PRIMARY KEY,
  `PokemonID` int DEFAULT NULL,
  `AbilityID` int DEFAULT NULL,
  FOREIGN KEY (`PokemonID`) REFERENCES `pokemon`(`PokemonID`),
  FOREIGN KEY (`AbilityID`) REFERENCES `ability`(`AbilityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - PokemonAbility.csv'
INTO TABLE pokemonability
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 11. typematchup DONE
CREATE TABLE `typematchup` (
  `TypeMatchupID` int PRIMARY KEY,
  `AttackingTypeID` int DEFAULT NULL,
  `DefendingTypeID` int DEFAULT NULL,
  `Effectiveness` double DEFAULT NULL,
  FOREIGN KEY (`AttackingTypeID`) REFERENCES `type`(`TypeID`),
  FOREIGN KEY (`DefendingTypeID`) REFERENCES `type`(`TypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - TypeMatchup.csv'
INTO TABLE typematchup
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 12. item DONE
CREATE TABLE `item` (
  `ItemID` int PRIMARY KEY,
  `ItemName` text DEFAULT NULL,
  `Item1TypeID` int DEFAULT NULL,
  `Item2TypeID` int DEFAULT NULL,
  FOREIGN KEY (`Item1TypeID`) REFERENCES `itemtype` (`ItemTypeID`),
  FOREIGN KEY (`Item2TypeID`) REFERENCES `itemtype` (`ItemTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - Item.csv'
INTO TABLE item
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET Item2TypeID = NULLIF (Item2TypeID, 777);


-- 13. maintrainers DONE using import table data wizard
CREATE TABLE `maintrainers` (
  `MainTrainerID` int PRIMARY KEY,
  `MainTrainerName` text DEFAULT NULL,
  `TitleID` int DEFAULT NULL,
  FOREIGN KEY (`TitleID`) REFERENCES `trainertitle`(`TitleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- did not work
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - MainTrainers.csv'
INTO TABLE maintrainers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 14. maintrainerteam DONE
CREATE TABLE `maintrainerteam` (
  `TeamID` int PRIMARY KEY,
  `MainTrainerID` int DEFAULT NULL,
  `EncounterNumber` int DEFAULT NULL,
  `LocationID` int DEFAULT NULL,
  `Reward` int DEFAULT NULL,
  `Item1ID` int DEFAULT NULL,
  `Item2ID` int DEFAULT NULL,
  `Item3ID` int DEFAULT NULL,
  `Item4ID` int DEFAULT NULL,
  FOREIGN KEY (`MainTrainerID`) REFERENCES `maintrainers`(`MainTrainerID`),
  FOREIGN KEY (`LocationID`) REFERENCES `location`(`LocationID`),
  FOREIGN KEY (`Item1ID`) REFERENCES `item`(`ItemID`),
  FOREIGN KEY (`Item2ID`) REFERENCES `item`(`ItemID`),
  FOREIGN KEY (`Item3ID`) REFERENCES `item`(`ItemID`),
  FOREIGN KEY (`Item4ID`) REFERENCES `item`(`ItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - MainTrainerTeam.csv'
INTO TABLE maintrainerteam
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET Item1ID = NULLIF(Item1ID, 777), Item2ID = NULLIF(Item2ID, 777), 
Item3ID = NULLIF(Item3ID, 777), Item4ID = NULLIF(Item4ID, 777);

-- 15. maintrainerpokemon DONE
CREATE TABLE `maintrainerpokemon` (
  `MainTrainerPokemonID` int PRIMARY KEY,
  `TeamID` int DEFAULT NULL,
  `PokemonID` int DEFAULT NULL,
  `Level` int DEFAULT NULL,
  `ItemID` int DEFAULT NULL,
  `Position` int DEFAULT NULL,
  `Move1ID` int DEFAULT NULL,
  `Move2ID` int DEFAULT NULL,
  `Move3ID` int DEFAULT NULL,
  `Move4ID` int DEFAULT NULL,
  `AbilityID` int DEFAULT NULL,
  `Gender` text DEFAULT NULL,
  FOREIGN KEY (`TeamID`) REFERENCES `maintrainerteam`(`TeamID`),
  FOREIGN KEY (`PokemonID`) REFERENCES `pokemon`(`PokemonID`),
  FOREIGN KEY (`ItemID`) REFERENCES `item`(`ItemID`),
  FOREIGN KEY (`Move1ID`) REFERENCES `move`(`MoveID`),
  FOREIGN KEY (`Move2ID`) REFERENCES `move`(`MoveID`),
  FOREIGN KEY (`Move3ID`) REFERENCES `move`(`MoveID`),
  FOREIGN KEY (`Move4ID`) REFERENCES `move`(`MoveID`),
  FOREIGN KEY (`AbilityID`) REFERENCES `ability`(`AbilityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - MainTrainerPokemon.csv'
INTO TABLE maintrainerpokemon
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET ItemID = NULLIF(ItemID, 777), Move3ID = NULLIF(Move3ID, 777), Move4ID = NULLIF(Move4ID, 777);

-- 16. ItemLocation DONE
CREATE TABLE `itemlocation` (
  `ItemLocationID` int PRIMARY KEY,
  `ItemID` int DEFAULT NULL,
  `LocationID` int DEFAULT NULL,
  FOREIGN KEY (`ItemID`) REFERENCES `item`(`ItemID`),
  FOREIGN KEY (`LocationID`) REFERENCES `location`(`LocationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - ItemLocation.csv'
INTO TABLE itemlocation
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
SET LocationID = NULLIF(LocationID, 777);

-- 17. tm DONE
CREATE TABLE `tm` (
  `TMID` int PRIMARY KEY,
  `TMName` text DEFAULT NULL,
  `LocationID` int DEFAULT NULL,
  `MoveID` int DEFAULT NULL,
  FOREIGN KEY (`LocationID`) REFERENCES `location`(`LocationID`),
  FOREIGN KEY (`MoveID`) REFERENCES `move`(`MoveID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - TM.csv'
INTO TABLE tm
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 18. gym DONE
CREATE TABLE `gym` (
  `GymID` int PRIMARY KEY,
  `GymName` text DEFAULT NULL,
  `LeaderID` int DEFAULT NULL,
  `LocationID` int DEFAULT NULL,
  `GymBadgeName` text DEFAULT NULL,
  `TMRewardID` int DEFAULT NULL,
  `TypeID` int DEFAULT NULL,
  `Effects` text DEFAULT NULL,
  FOREIGN KEY (`LeaderID`) REFERENCES `maintrainers` (`MainTrainerID`),
  FOREIGN KEY (`LocationID`) REFERENCES `location` (`LocationID`),
  FOREIGN KEY (`TMRewardID`) REFERENCES `tm` (`TMID`),
  FOREIGN KEY (`TypeID`) REFERENCES `type` (`TypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pokemon_bw/Final Pokemon Black and White Database - Gym.csv'
INTO TABLE gym
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;