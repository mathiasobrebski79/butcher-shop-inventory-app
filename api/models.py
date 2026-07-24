from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field

class Inventory(BaseModel):
    uuid: str
    created_at: datetime
    form_type: str
    items: list[dict[str, Any]]

    @property
    def received_at(self) -> str:

        return datetime.now().isoformat()

# class InventoryItem(BaseModel):

#     """
#     Un élément physique inventorié.

#     Exemple :
#     une carcasse,
#     une caisse,
#     un roll,
#     une pièce PAD.
#     """


#     data: dict[str, Any] = Field(
#         default_factory=dict
#     )





# class Inventory(BaseModel):

#     """
#     Un inventaire complet.

#     Un inventaire contient plusieurs items.
#     """

#     uuid: str

#     created_at: datetime

#     form_type: str = "cold_room"

#     items: list[InventoryItem]



#     @property
#     def received_at(self) -> str:

#         return datetime.now().isoformat()