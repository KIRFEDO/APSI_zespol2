# APSI_zespol2
### Wymagania:
Postgresql > https://www.postgresql.org/download/
### Uruchomienie aplikacji:
Polecenia z (Init) do wykonania tylko przy pierwszym uruchamianiu.

1. (Init) Przygotowanie venva:
`python -m venv venv`

2. **Uruchomienie venva:**
`.\venv\Scripts\activate`

3. (Init) Instalacja zależności:
`pip install -r requirements.txt`

4. (Init) Utworzenie bazy danych:
`psql -U postgres -f database.sh`
Zalogowanie się do postgresa hasłem ustalonym przy instalacji.

5. **Uruchomienie apki:**
`python run.py`
