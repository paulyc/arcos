create type business_activity as enum(
  'DISTRIBUTOR', 
  'PRACTITIONER'
);
-- technically mass, but de facto weight, since it is in reality 
-- determined with a scale in some random place on planet earth
create type unit_weight as (
  'G',
  'MG',
  'MCG'
); 
create type address as (
  id bigint auto_increment primary key, 
  name text null, 
  co_info text null, 
  address1 text null,
  address2 text null,
  city text null, 
  state text null, 
  zip text null, 
  county text null
);
create table registered_entity(
  id bigint auto_increment primary key, 
  dea_number text, 
  activity business_activity, null
  addr address null
);

-- like an actual chemical compound
create table drug_compound(
  id bigint auto_increment primary key,
  -- eg, raw data 'MORPHINE SULFATE PENTAHYDRATE(I.E.,5H20)' => 
  -- canonical name 'MORPHINE SULFATE PENTAHYDRATE'
  canonical_name text
); 

-- like ms contin or generic morphine and dosage
create table drug_product(
  id bigint auto_increment primary key, 
  canonical_name text,
  drug_compound_id bigint null, -- refs drug_compound
  -- eg, raw data, 'MORPHINE SULFATE 15MG/ML USP SOLUTIO' => 
  -- canonical probably '15MG/ML' as the rest is redundant, either internally or given the compound table
  canonical_preparation_name text null
);

-- like one specific line item on a purchase invoice, compound, product, quantity, etc
create table drug_sku(
  id bigint auto_increment primary key,
  drug_product_id bigint, -- refs drug_product
  net_weight decimal, 
  unit unit_weight
);

create table transaction(
  id bigint auto_increment primary key,
  reporter_entity_id bigint, -- refs registered_entity
  buyer_entity_id bigint, -- refs registered_entity
  code_ text, -- see TFM
  txdate datetime, 
  sku bigint, -- refs drug_sku
  quantity decimal
);
