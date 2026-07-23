import json
import sqlite3
from pathlib import Path


DB_FILE = Path("inventories.db")


class Database:

    def __init__(self):
        self.connection = sqlite3.connect(
            DB_FILE,
            check_same_thread=False,
        )
        self.connection.row_factory = sqlite3.Row

    def init(self):

        cursor = self.connection.cursor()

        cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS inventories(

                id INTEGER PRIMARY KEY AUTOINCREMENT,

                uuid TEXT UNIQUE NOT NULL,

                created_at TEXT NOT NULL,

                received_at TEXT NOT NULL,

                form_type TEXT NOT NULL,

                item_count INTEGER NOT NULL,

                data_json TEXT NOT NULL

            )
            """
        )

        self.connection.commit()

    def save_inventory(self, inventory):

        cursor = self.connection.cursor()

        cursor.execute(
            """
            INSERT OR REPLACE INTO inventories
            (
                uuid,
                created_at,
                received_at,
                form_type,
                item_count,
                data_json
            )

            VALUES
            (
                ?,?,?,?,?,?
            )
            """,
            (
                inventory.uuid,
                inventory.created_at,
                inventory.received_at,
                inventory.form_type,
                len(inventory.items),
                json.dumps(
                    inventory.model_dump(mode="json")
                    ),
            ),
        )

        self.connection.commit()

    def list_inventories(self):

        cursor = self.connection.cursor()

        cursor.execute(
            """
            SELECT
                id,
                uuid,
                created_at,
                received_at,
                form_type,
                item_count
            FROM inventories

            ORDER BY created_at DESC
            """
        )

        return cursor.fetchall()

    def get_inventory(self, uuid):

        cursor = self.connection.cursor()

        cursor.execute(
            """
            SELECT data_json

            FROM inventories

            WHERE uuid=?
            """,
            (uuid,),
        )

        row = cursor.fetchone()

        if row is None:
            return None

        return json.loads(row["data_json"])


db = Database()