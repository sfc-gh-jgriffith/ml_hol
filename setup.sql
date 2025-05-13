USE ROLE ACCOUNTADMIN;
use warehouse compute_wh;


/************************
 * Create Git integration
 ***********************/

CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/')
  ENABLED = TRUE;

create or replace database git_db;

/************************
 * Setup HOL 1
 ***********************/

CREATE OR REPLACE GIT REPOSITORY git_db.public.ml_intro
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/Snowflake-Labs/sfguide-intro-to-machine-learning-with-snowflake-ml-for-python';

ls @git_db.public.ml_intro/branches/main;

execute immediate from @git_db.public.ml_intro/branches/main/scripts/setup.sql;

USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE NOTEBOOK HOL_0_start_here
  FROM '@git_db.public.ml_intro/branches/main/notebooks'
  MAIN_FILE = '0_start_here.ipynb' 
  QUERY_WAREHOUSE = ML_HOL_WH
  WAREHOUSE =  ML_HOL_WH;

CREATE OR REPLACE NOTEBOOK HOL_1_feature_transformation
  FROM '@git_db.public.ml_intro/branches/main/notebooks'
  MAIN_FILE = '1_sf_nb_snowflake_ml_feature_transformations.ipynb' 
  QUERY_WAREHOUSE = ML_HOL_WH
  WAREHOUSE =  ML_HOL_WH;

CREATE OR REPLACE NOTEBOOK HOL_2_training_inference
  FROM '@git_db.public.ml_intro/branches/main/notebooks'
  MAIN_FILE = '2_sf_nb_snowflake_ml_model_training_inference.ipynb' 
  QUERY_WAREHOUSE = ML_HOL_WH
  WAREHOUSE =  ML_HOL_WH;

CREATE OR REPLACE NOTEBOOK HOL_3_advanced_mlops
  FROM '@git_db.public.ml_intro/branches/main/notebooks'
  MAIN_FILE = '3_sf_nb_snowpark_ml_adv_mlops.ipynb' 
  QUERY_WAREHOUSE = ML_HOL_WH
  WAREHOUSE =  ML_HOL_WH;
  

/************************
 * Setup HOL 2
 ***********************/  
USE ROLE ACCOUNTADMIN;
use warehouse compute_wh;
 
CREATE OR REPLACE GIT REPOSITORY git_db.public.featurestore_registry_demo
  API_INTEGRATION = git_api_integration
  ORIGIN = 'https://github.com/Snowflake-Labs/sfguide-develop-and-manage-ml-models-with-feature-store-and-model-registry.git';

CREATE OR REPLACE ROLE ML_MODEL_ROLE;
GRANT ROLE ML_MODEL_ROLE to ROLE ACCOUNTADMIN;

-- create our virtual warehouse
CREATE OR REPLACE WAREHOUSE ML_MODEL_WH;
GRANT USAGE ON WAREHOUSE ML_MODEL_WH TO ROLE ML_MODEL_ROLE;


-- Next create a new database and schema,
CREATE OR REPLACE DATABASE ML_MODEL_DATABASE;
CREATE OR REPLACE SCHEMA ML_MODEL_SCHEMA;

grant usage on database ML_MODEL_DATABASE to role ML_MODEL_ROLE;

grant all on schema ML_MODEL_DATABASE.ML_MODEL_SCHEMA to role ML_MODEL_ROLE;


CREATE OR REPLACE NOTEBOOK ML_MODEL_DATABASE.ML_MODEL_SCHEMA.HOL_feat_store_registry
  FROM '@git_db.public.featurestore_registry_demo/branches/main/notebooks'
  MAIN_FILE = '0_start_here.ipynb' 
  QUERY_WAREHOUSE = ML_MODEL_WH
  WAREHOUSE =  ML_MODEL_WH;

