--credit score density status
SELECT
	user_id,
	credit_score,
	CASE
		WHEN default_flag = 1 THEN 'Defaulter'
		ELSE 'Good Standing'
	END as status
FROM
	users
	-- Compare Credit Score profiles between Defaulters and Good Users
SELECT
	CASE
		WHEN default_flag = 1 THEN 'Defaulter'
		ELSE 'Good User'
	END AS user_status,
	COUNT(user_id) AS user_count,
	ROUND(AVG(credit_score), 0) AS avg_credit_score,
	MIN(credit_score) AS min_score,
	MAX(credit_score) AS max_score
FROM
	users
GROUP BY
	default_flag
	--Total amount of each category     
SELECT
	CASE
		WHEN category IS NULL
		OR category = '' THEN 'Unclassified'
		ELSE category
	END as category_clean,
	SUM(amount) as total_volume
FROM
	transactions
GROUP BY
	1
ORDER BY
	total_volume DESC
	--category defaulters
SELECT
	CASE
		WHEN t.category IS NULL
		OR category = '' THEN 'Unclassified'
		ELSE t.category
	END as category,
	AVG(u.default_flag) * 100 as default_rate
FROM
	transactions t
JOIN users u ON
	t.user_id = u.user_id
GROUP BY
	1
ORDER BY
	default_rate ASC
	--30 days Transaction Volume
SELECT
	DATE(transaction_date) as day,
	COUNT(*) as transaction_volume
FROM
	transactions
WHERE
	transaction_date >= DATE((SELECT MAX(transaction_date) FROM transactions), '-30 days')
GROUP BY
	day
ORDER BY
	day;
-- Objective: Track daily transaction volume over the last 30 days
SELECT
	DATE(transaction_date) as transaction_day,
	COUNT(transaction_id) as daily_volume,
	SUM(amount) as daily_value
FROM
	transactions
GROUP BY
	1
ORDER BY
	1 ASC;
--Top Users Query
SELECT
	user_id,
	COUNT(transaction_id) as transaction_count
FROM
	transactions t
GROUP BY
	user_id
ORDER BY
	transaction_count DESC
LIMIT 5
--latest transcation per user
SELECT
	*
FROM
	transactions t1
WHERE
	transaction_date = (
	SELECT
		MAX(transaction_date)
	FROM
		transactions t2
	WHERE
		t2.user_id = t1.user_id
)
