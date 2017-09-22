# Robocrop 🤖 🌿

## A soil moisture meter system

Sensor data is acquired via Arduino -(UDP)-> UDP Server -> PostgreSQL

Users facing system is an SPA -> REST API -> PostgreSQL


System components:
- Hardware (Arduino mkr1000 + FC-28 Soil moisture sensor)
- Arduino script
- UDP Server
- Database
- REST API
- Elm SPA

Features:
- [x] Retrieve latest readings for all plants
- [ ] Allow users to modify plant data (name, species, etc)
- [ ] User system supporting authentication
