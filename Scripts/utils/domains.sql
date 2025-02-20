-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------

CREATE DOMAIN active       AS BOOLEAN NOT NULL DEFAULT TRUE;
CREATE DOMAIN city_name    AS TEXT CHECK (VALUE ~ '^[A-Za-z]+([ -][A-Za-z]+)*$');
CREATE DOMAIN description  AS TEXT;
CREATE DOMAIN email        AS TEXT CHECK (VALUE ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
CREATE DOMAIN pk           AS UUID DEFAULT gen_random_uuid();
CREATE DOMAIN fk           AS UUID;
CREATE DOMAIN generic_name AS TEXT CHECK (VALUE ~ '^[A-Za-z]+(['' -][A-Za-z]+)*$');
CREATE DOMAIN phone_number AS TEXT CHECK (VALUE ~ '^\d{3}-\d{3}-\d{4}$');
CREATE DOMAIN state        AS CHAR(2)
  CHECK (VALUE IN (
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 
    'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
  ));

CREATE DOMAIN timestamp_at AS TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP;
CREATE DOMAIN username     AS TEXT NOT NULL;
CREATE DOMAIN zip_code     AS TEXT CHECK (VALUE ~ '^\d{5}(-\d{4})?$');

