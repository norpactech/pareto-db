-- ----------------------------------------------------------------------------
-- © 2025 Northern Pacific Technologies, LLC.
-- Licensed under the MIT License.
-- See LICENSE file in the project root for full license information.
-- ----------------------------------------------------------------------------
-- Test script for multi-tenancy RLS policies
-- This script tests that tenant isolation is working correctly
-- ----------------------------------------------------------------------------

-- Clean up any existing test data

\echo '=== Beginning Multi-tenancy RLS test ==='

-- Simple RLS test for multi-tenancy
-- Run this with: psql -h localhost -U web_update -d norpac -f test-multi-tenancy.sql

\echo '=== Simple RLS Test ==='

-- Check current user
\echo 'Current user:'
SELECT current_user;

-- Set tenant context
SET app.current_tenant = '5412732c-58ad-4805-bf0c-455890161000';

\echo 'Current tenant setting:'
SELECT current_setting('app.current_tenant') as current_tenant;

-- Try basic query
\echo 'Testing schema access:'
SELECT 'Schema count' as description, count(*) as count FROM pareto.schema;

\echo 'Schema details:'
SELECT id, name FROM pareto.schema LIMIT 3;

-- Try basic query
\echo 'Testing context access:'
SELECT 'Context count' as description, count(*) as count FROM pareto.context;


\echo '=== Test Complete ==='

\echo '=== Completed Multi-tenancy RLS test ==='