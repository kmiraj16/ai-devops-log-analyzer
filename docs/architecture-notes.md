# Architecture Notes

## Current Local Architecture

User
↓
HTML UI
↓
FastAPI Service
↓
Rule-based Log Analyzer

## Week 3 Goal

Add PostgreSQL so analysis results are stored and retrieved.

## Planned Table: analyses

Fields:
- id
- log_text
- root_cause
- suggestion
- created_at

## Why This Matters

This makes the app stateful and more realistic, instead of being a temporary in-memory demo.