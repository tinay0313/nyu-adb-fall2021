.mode csv

DROP TABLE IF EXISTS fractal_trade;
.import ./trade_table.csv fractal_trade
.schema fractal_trade

SELECT "*********************FRACTAL************************";

DROP TABLE IF EXISTS all_col;
SELECT "Retrieving all columns...";
.timer ON
CREATE TABLE all_col AS
SELECT * FROM fractal_trade;
.timer OFF
SELECT "****************************************************";

DROP TABLE IF EXISTS need_col;
SELECT "Retrieving just the needed columns...";
.timer ON
CREATE TABLE need_col AS
SELECT stock, price FROM fractal_trade;
.timer OFF
SELECT "****************************************************";

DROP TABLE IF EXISTS no_clustered_idx;
SELECT "Without clustered index on price...";
.timer ON
CREATE TABLE no_clustered_idx AS
SELECT stock FROM fractal_trade
WHERE price > 2500;
.timer OFF
SELECT "****************************************************";

DROP TABLE IF EXISTS sorted_fractal;
CREATE TABLE sorted_fractal AS
SELECT * FROM fractal_trade
ORDER BY price;

DROP TABLE IF EXISTS clustered_idx;
SELECT "With clustered index on price...";
.timer ON
CREATE TABLE clustered_idx AS
SELECT stock FROM sorted_fractal
WHERE price > 2500;
.timer OFF
SELECT "****************************************************";

DROP TABLE IF EXISTS uniform_trade;
.import ./trade_uniform.csv uniform_trade
.schema uniform_trade

SELECT "*********************UNIFORM***********************";

DROP TABLE IF EXISTS all_col;
SELECT "Retrieving all columns...";
.timer ON
CREATE TABLE all_col AS
SELECT * FROM uniform_trade;
.timer OFF
SELECT "****************************************************";

DROP TABLE IF EXISTS need_col;
SELECT "Retrieving just the needed columns...";
.timer ON
CREATE TABLE need_col AS
SELECT stock, price FROM uniform_trade;
.timer OFF
SELECT "****************************************************";

DROP TABLE IF EXISTS no_clustered_idx;
SELECT "Without clustered index on price...";
.timer ON
CREATE TABLE no_clustered_idx AS
SELECT stock FROM uniform_trade
WHERE price > 2500;
.timer OFF
SELECT "****************************************************";

DROP TABLE IF EXISTS sorted_uniform;
CREATE TABLE sorted_uniform AS
SELECT * FROM uniform_trade
ORDER BY price;

DROP TABLE IF EXISTS clustered_idx;
SELECT "With clustered index on price...";
.timer ON
CREATE TABLE clustered_idx AS
SELECT stock FROM sorted_uniform
WHERE price > 2500;
.timer OFF