import org.ofbiz.base.util.Debug

/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

orderId = parameters.orderId;
partyId = parameters.partyId;
productId = parameters.productId;
inventoryItemId = parameters.inventoryItemId;
if (parameters.searchValueFieldName && parameters.searchValueFieldName.equals("inventoryItemId"))
    inventoryItemId = parameters.term;

Debug.log("parameters.inventoryItemId ========> " + inventoryItemId);

if (orderId && productId) {
    shipmentReceiptAndItems = from("ShipmentReceiptAndItem").where("orderId", orderId, "productId", productId).queryList();
    context.inventoryItemsForPo = shipmentReceiptAndItems;
    context.orderId = orderId;
}

if (partyId && productId) {
    orderRoles = from("OrderRole").where("partyId", partyId, "roleTypeId", "BILL_FROM_VENDOR").queryList();
    inventoryItemsForSupplier = [];
    orderRoles.each { orderRole ->
        shipmentReceiptAndItems = from("ShipmentReceiptAndItem").where("productId", productId, "orderId", orderRole.orderId).queryList();
        inventoryItemsForSupplier.addAll(shipmentReceiptAndItems);
    }
    context.inventoryItemsForSupplier = inventoryItemsForSupplier;
    context.partyId = partyId;
}

if (productId) {
    inventoryItems = from("InventoryItem").where("productId", productId).queryList();
    context.inventoryItemsForProduct = inventoryItems;
    context.productId = productId;
    product = from("Product").where("productId", productId).queryOne();
    context.internalName = product.internalName;
}

if (inventoryItemId) {
    inventoryItem = from("InventoryItem").where("inventoryItemId", inventoryItemId).queryOne();
    context.inventoryItem = inventoryItem;
    Debug.log("inventoryItem ======> " + inventoryItem);
    if (inventoryItem) {
        product = inventoryItem.getRelatedOne("Product", false);
        context.internalName = product.internalName;
    }
}