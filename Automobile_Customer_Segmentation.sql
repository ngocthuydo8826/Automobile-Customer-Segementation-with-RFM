WITH rfm AS(
	SELECT 
		customername
		,MAX(orderdate) AS last_order_day
		,MIN(days_since_lastorder) AS recency
		,COUNT(DISTINCT ordernumber) AS frequency
		,SUM(sales) AS monetary
	FROM rfm
	GROUP BY customername
)

, rfm_rank AS(
	SELECT *
		,CASE 
			WHEN recency BETWEEN 41 AND 228.6 THEN 5
			WHEN recency BETWEEN 229 AND 339.2 THEN 4
			WHEN recency BETWEEN 340 AND 480.6 THEN 3
			WHEN recency BETWEEN 481 AND 659 THEN 2
			WHEN recency BETWEEN 659 AND 1353 THEN 1
		END AS recency_rank
	
		,CASE
			WHEN frequency BETWEEN 0 AND 18.6 THEN 1
			WHEN frequency BETWEEN 19 AND 36.2 THEN 2
			WHEN frequency BETWEEN 37 AND 53.8 THEN 3
			WHEN frequency BETWEEN 54 AND 71.4 THEN 4
			WHEN frequency BETWEEN 72 AND 89 THEN 5
		END AS frequency_rank
	
		,CASE
			WHEN monetary BETWEEN 9129 AND 64737.176 THEN 1
			WHEN monetary BETWEEN 64737.176 AND 79665.352 THEN 2
			WHEN monetary BETWEEN 79665.352 AND 100537.756 THEN 3
			WHEN monetary BETWEEN 100537.756 AND 132714.912 THEN 4
			WHEN monetary BETWEEN 132714.912 AND 912294.11 THEN 5
		END AS monetary_rank
	FROM rfm
)
,concat_rfm AS(
	SELECT *
		,CONCAT(recency_rank, frequency_rank, monetary_rank) AS rfm_group
	FROM rfm_rank
)
SELECT *
	,CASE 
		WHEN rfm_group IN ('555','554','544','545','454','455','445') THEN 'Champions'
		WHEN rfm_group IN ('543','444','435','355','354','345','344','335') THEN 'Loyal Customer'
		WHEN rfm_group IN ('553','551','552','541','542','533','532', '531','452','451','442','441','431','453','433',
		                   '432','423','353','352','351','342','341','333','323') THEN 'Potential Loyalist'
		WHEN rfm_group IN ('512','511','422','421','412','411','311') THEN 'Recent Customer'
		WHEN rfm_group IN ('525','524','523','522','521','515','514','513','425','424','413','414','415','315','314','313') THEN 'Promising'
		WHEN rfm_group IN ('535', '534', '443', '434', '343', '334', '325', '324') THEN 'Customer Needs Attention'
		WHEN rfm_group IN ('331','321','312','221','213') THEN 'About to Sleep'
		WHEN rfm_group IN ('255','254','245','244','253','252','243','242','235','234','225','224',
		                   '153','152','145','143','142','135','134','133','125','124') THEN 'At Risk'
		WHEN rfm_group IN ('155','154','144','214','215','115','114','113') THEN 'Cant Lost Them'
		WHEN rfm_group IN ('332','322','331','241','251','233','232','223','222','132','123','122','212','211') THEN 'Hibernating'
		WHEN rfm_group IN ('111','112','121','131','141','151') THEN 'Lost'

	END AS rfm_segment
FROM concat_rfm
