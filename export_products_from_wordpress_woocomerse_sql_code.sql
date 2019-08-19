--  GET BLOG POSTS 
SELECT p1.*, wm2.meta_value FROM rwcex_posts p1 LEFT JOIN
rwcex_postmeta wm1 ON (
wm1.post_id = p1.id
AND wm1.meta_value IS NOT NULL
AND wm1.meta_key = "_thumbnail_id"
)
LEFT JOIN rwcex_postmeta wm2 ON (wm1.meta_value = wm2.post_id AND wm2.meta_key = "_wp_attached_file"
AND wm2.meta_value IS NOT NULL) WHERE p1.post_status="publish" AND p1.post_type="post"
ORDER BY p1.post_date DESC;

-- All Categories [ id-> term_id,  parent_id => parent, title=> name] ...
SELECT name, slug, parent, t.term_id FROM rwcex_posts AS pp JOIN rwcex_term_relationships tr ON pp.id = tr.object_id JOIN rwcex_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id JOIN rwcex_terms t ON tt.term_id = t.term_id || tt.parent = t.term_id WHERE tt.taxonomy = 'product_cat' GROUP BY name;


-- PRODUCTS [ id, name, code, price, categories ids]
SELECT
  rwcex_posts.ID AS product_id,
  rwcex_posts.post_title AS Product,
  rwcex_postmeta1.meta_value AS SKU,
  rwcex_postmeta2.meta_value AS Price,
  GROUP_CONCAT( rwcex_terms.term_id ORDER BY rwcex_terms.name SEPARATOR ', ' ) AS ProductCategories
FROM rwcex_posts
LEFT JOIN rwcex_postmeta rwcex_postmeta1
  ON rwcex_postmeta1.post_id = rwcex_posts.ID
  AND rwcex_postmeta1.meta_key = '_sku'
LEFT JOIN rwcex_postmeta rwcex_postmeta2
  ON rwcex_postmeta2.post_id = rwcex_posts.ID
  AND rwcex_postmeta2.meta_key = '_regular_price'
LEFT JOIN rwcex_term_relationships
  ON rwcex_term_relationships.object_id = rwcex_posts.ID
LEFT JOIN rwcex_term_taxonomy
  ON rwcex_term_relationships.term_taxonomy_id = rwcex_term_taxonomy.term_taxonomy_id
  AND rwcex_term_taxonomy.taxonomy = 'product_cat'
LEFT JOIN rwcex_terms
  ON rwcex_term_taxonomy.term_id = rwcex_terms.term_id
WHERE rwcex_posts.post_type = 'product'
AND rwcex_posts.post_status = 'publish'
GROUP BY rwcex_posts.ID
ORDER BY rwcex_posts.post_title ASC;


-- PRodukt Atttributes --- 
SELECT p.`ID` AS 'Product ID',
       p.`post_title` AS 'Product Name',
       t.`term_id` AS 'Attribute Value ID',
       REPLACE(REPLACE(tt.`taxonomy`, 'pa_', ''), '-', ' ') AS 'Attribute Name',
       t.`name` AS 'Attribute Value'
FROM `rwcex_posts` AS p
INNER JOIN `rwcex_term_relationships` AS tr ON p.`ID` = tr.`object_id`
INNER JOIN `rwcex_term_taxonomy` AS tt ON tr.`term_taxonomy_id` = tt.`term_id`
AND tt.`taxonomy` LIKE 'pa_%'
INNER JOIN `rwcex_terms` AS t ON tr.`term_taxonomy_id` = t.`term_id`
WHERE p.`post_type` = 'product'
  AND p.`post_status` = 'publish'
ORDER BY p.`ID`;