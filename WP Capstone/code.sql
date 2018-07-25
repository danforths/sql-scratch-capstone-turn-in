/* Part 1.  What columns does the table have?
*/
SELECT *
FROM survey
LIMIT 10;

/* Part 2.  What is the number of responses for each question?
*/
SELECT question,
	COUNT(*)
FROM survey
GROUP BY question;

/* Part 3.  Exploring Question 5
*/
SELECT question, 
	response,
COUNT(response)
FROM survey
WHERE question = '5. When was your last eye exam?'
GROUP BY response;



/* New table within the WITH function.  Conversion Rates during Funnel Stages
*/
WITH warby_funnel AS ( SELECT DISTINCT q.user_id,
	h.user_id IS NOT NULL AS 'is_home_try_on',
	h.number_of_pairs,
	p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
LEFT JOIN purchase p
	ON p.user_id = q.user_id)
 
SELECT COUNT(user_id) AS 'num_prospect',
	SUM(is_home_try_on) AS 'num_home_try_on',
	SUM(is_purchase) AS 'num_purchase',
	1.0*SUM(is_home_try_on)/count(user_id) AS 'q_to_hto_cr',
	1.0*SUM(is_purchase)/SUM(is_home_try_on) AS 'hto_to_p_cr',
	1.0*SUM(is_purchase)/count(user_id) AS 'overall_cr'
FROM warby_funnel;



/* AB Test of 3 and 5 Glasses Home Try Ons
*/
WITH warby_funnel AS ( SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)

SELECT number_of_pairs,
   COUNT(user_id) AS 'num_prospect',
   SUM(is_home_try_on) AS 'num_home_try_on',
   SUM(is_purchase) AS 'num_purchase',
   1.0*SUM(is_home_try_on)/count(user_id) AS 'q_to_hto_cr',
   1.0*SUM(is_purchase)/SUM(is_home_try_on) AS 'hto_to_p_cr',
   1.0*SUM(is_purchase)/count(user_id) AS 'overall_cr'
FROM warby_funnel
WHERE number_of_pairs IS NOT NULL
GROUP BY number_of_pairs;





/* Most Popular Style Quiz
*/
SELECT DISTINCT style, shape, fit, color, count(user_id)
FROM quiz
GROUP BY 1, 2, 3, 4
ORDER BY count(user_id) DESC
LIMIT 5;



/* Most Popular Purchases
*/
SELECT DISTINCT model_name, 
	style, 
	color,
	sum(price) AS 'revenue',
	count(price) AS 'num_purchased', 
	price
FROM purchase
GROUP BY 1,2,3
ORDER BY num_purchased DESC;


/*Most popular color frames
*/
SELECT DISTINCT color,
	sum(price) AS 'revenue',
	count(price) AS 'num_purchased', 
	price
FROM purchase
GROUP BY color
ORDER BY num_purchased desc;
