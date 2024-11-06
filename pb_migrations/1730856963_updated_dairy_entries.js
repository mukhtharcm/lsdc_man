/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("35hutfa1k0lbavt")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "ppxsdkjq",
    "name": "total",
    "type": "number",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "noDecimal": false
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("35hutfa1k0lbavt")

  // remove
  collection.schema.removeField("ppxsdkjq")

  return dao.saveCollection(collection)
})
