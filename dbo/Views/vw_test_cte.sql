
CREATE VIEW [dbo].[vw_test_cte]
AS

WITH cte AS (
SELECT 1 AS a
)

SELECT * FROM cte