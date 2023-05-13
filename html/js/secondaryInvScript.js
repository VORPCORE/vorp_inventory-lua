function PostAction(eventName, itemData) {
  if (itemData.type != "item_weapon") {
    dialog.prompt({
      title: LANGUAGE.prompttitle,
      button: LANGUAGE.promptaccept,
      required: true,
      item: itemData,
      type: itemData.type,
      input: {
        type: "number",
        autofocus: "true",
      },

      validate: function (value, item, type) {
        if (value || value > 0 || value < 200 || isInt(value)) {
          if (!isValidating) {
            processEventValidation();
            $.post(
              `https://${GetParentResourceName()}/${eventName}`,
              JSON.stringify({
                item: itemData,
                type: type,
                number: value,
                id: customId,
              })
            );
          }
        } else {
          dialog.close();
          return;
        }
      },
    });
  } else {
    if (!isValidating) {
      processEventValidation();
      $.post(
        `https://${GetParentResourceName()}/${eventName}`,
        JSON.stringify({
          item: itemData,
          type: itemData.type,
          number: 1,
          id: customId,
        })
      );
    }
  }
}

function initSecondaryInventoryHandlers() {
  $("#inventoryElement").droppable({
    drop: function (event, ui) {
      itemData = ui.draggable.data("item");
      itemInventory = ui.draggable.data("inventory");
      if (itemInventory === "second") {
        if (type === "custom") {
          disableInventory(500);
          PostAction("TakeFromCustom", itemData);
        } else if (type === "horse") {
          disableInventory(500);
          PostAction("TakeFromHorse", itemData);
        } else if (type === "store") {
          disableInventory(500);
          if (itemData.type != "item_weapon") {
            dialog.prompt({
              title: LANGUAGE.prompttitle,
              button: LANGUAGE.promptaccept,
              required: true,
              item: itemData,
              type: itemData.type,
              input: {
                type: "number",
                autofocus: "true",
              },

              validate: function (value, item, type) {
                if (!value) {
                  dialog.close();
                  return;
                }

                if (!isInt(value)) {
                  return;
                }

                if (!isValidating) {
                  processEventValidation();
                  $.post(
                    `https://${GetParentResourceName()}/TakeFromStore`,
                    JSON.stringify({
                      item: itemData,
                      type: type,
                      number: value,
                      price: itemData.price,
                      geninfo: geninfo,
                      store: StoreId,
                    })
                  );
                }
              },
            });
          } else {
            if (!isValidating) {
              processEventValidation();
              $.post(
                `https://${GetParentResourceName()}/TakeFromStore`,
                JSON.stringify({
                  item: itemData,
                  type: itemData.type,
                  number: 1,
                  price: itemData.price,
                  geninfo: geninfo,
                  store: StoreId,
                })
              );
            }
          }
        } else if (type === "cart") {
          disableInventory(500);
          PostAction("TakeFromCart", itemData);
        } else if (type === "house") {
          disableInventory(500);
          PostAction("TakeFromHouse", itemData);
        } else if (type === "hideout") {
          disableInventory(500);
          PostAction("TakeFromHideout", itemData);
        } else if (type === "bank") {
          disableInventory(500);
          PostAction("TakeFromBank", itemData);
        } else if (type === "clan") {
          disableInventory(500);
          PostAction("TakeFromClan", itemData);
        } else if (type === "steal") {
          disableInventory(500);
          PostAction("TakeFromsteal", itemData);
        } else if (type === "Container") {
          disableInventory(500);
          PostAction("TakeFromContainer", itemData);
        }
      }
    },
  });

  $("#secondInventoryElement").droppable({
    drop: function (event, ui) {
      itemData = ui.draggable.data("item");
      itemInventory = ui.draggable.data("inventory");

      if (itemInventory === "main") {
        if (type === "custom") {
          disableInventory(500);
          PostAction("MoveToCustom", itemData);
        } else if (type === "horse") {
          disableInventory(500);
          PostAction("MoveToHorse", itemData);
        } else if (type === "store") {
          disableInventory(500);
          // this action is different than all the others
          if (itemData.type != "item_weapon") {
            dialog.prompt({
              title: LANGUAGE.prompttitle,
              button: LANGUAGE.promptaccept,
              required: true,
              item: itemData,
              type: itemData.type,
              input: {
                type: "number",
                autofocus: "true",
              },
              validate: function (value, item, type) {
                if (!value) {
                  dialog.close();
                  return;
                }

                if (!isInt(value)) {
                  return;
                }

                if (geninfo.isowner != 0) {
                  if (!isValidating) {
                    processEventValidation();
                    dialog.prompt({
                      title: LANGUAGE.prompttitle2,
                      button: LANGUAGE.promptaccept,
                      required: true,
                      item: itemData,
                      type: itemData.type,
                      input: {
                        type: "number",
                        autofocus: "true",
                      },
                      validate: function (value2, item, type) {
                        if (!value2) {
                          dialog.close();
                          return;
                        }

                        if (!isValidating) {
                          processEventValidation();
                          $.post(
                            `https://${GetParentResourceName()}/MoveToStore`,
                            JSON.stringify({
                              item: itemData,
                              type: type,
                              number: value,
                              price: value2,
                              geninfo: geninfo,
                              store: StoreId,
                            })
                          );
                        }
                      },
                    });
                  }
                } else {
                  if (!isValidating) {
                    processEventValidation();
                    $.post(
                      `https://${GetParentResourceName()}/MoveToStore`,
                      JSON.stringify({
                        item: itemData,
                        type: type,
                        number: value,
                        geninfo: geninfo,
                        store: StoreId,
                      })
                    );
                  }
                }
              },
            });
          } else {
            if (geninfo.isowner != 0) {
              dialog.prompt({
                title: LANGUAGE.prompttitle2,
                button: LANGUAGE.promptaccept,
                required: true,
                item: itemData,
                type: itemData.type,
                input: {
                  type: "number",
                  autofocus: "true",
                },
                validate: function (value2, item, type) {
                  if (!value2) {
                    dialog.close();
                    return;
                  }

                  if (!isValidating) {
                    processEventValidation();
                    $.post(
                      `https://${GetParentResourceName()}/MoveToStore`,
                      JSON.stringify({
                        item: itemData,
                        type: itemData.type,
                        number: 1,
                        price: value2,
                        geninfo: geninfo,
                        store: StoreId,
                      })
                    );
                  }
                },
              });
            } else {
              if (!isValidating) {
                processEventValidation();
                $.post(
                  `https://${GetParentResourceName()}/MoveToStore`,
                  JSON.stringify({
                    item: itemData,
                    type: itemData.type,
                    number: 1,
                    geninfo: geninfo,
                    store: StoreId,
                  })
                );
              }
            }
          }
        } else if (type === "cart") {
          disableInventory(500);
          PostAction("MoveToCart", itemData);
        } else if (type === "house") {
          disableInventory(500);
          PostAction("MoveToHouse", itemData);
        } else if (type === "hideout") {
          disableInventory(500);
          PostAction("MoveToHideout", itemData);
        } else if (type === "bank") {
          disableInventory(500);
          PostAction("MoveToBank", itemData);
        } else if (type === "clan") {
          disableInventory(500);
          PostAction("MoveToClan", itemData);
        } else if (type === "steal") {
          disableInventory(500);
          PostAction("MoveTosteal", itemData);
        } else if (type === "Container") {
          disableInventory(500);
          PostAction("MoveToContainer", itemData);
        }
      }
    },
  });
}

function secondInventorySetup(items) {
  $("#inventoryElement").html("");
  $("#secondInventoryElement").html("");

  $.each(items, function (index, item) {
    count = item.count;

    if (item.type !== "item_weapon") {
      $("#secondInventoryElement").append(`
      <div data-label="${item.label}"' 
      style='background-image: url(\"img/items/${
        item.name ? item.name.toLowerCase() : ""
      }.png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;'
      id="item-${index}" class='item'>
          ${count > 0 ? `<div class='count'>${count}</div>` : ``}
          <div class='text'></div>
      </div>
  `);
    } else {
      $("#secondInventoryElement").append(
        "<div data-label='" +
          item.label +
          "' style='background-image: url(\"img/items/" +
          item.name.toLowerCase() +
          ".png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;' id='item-" +
          index +
          "' class='item'></div></div>"
      );
    }

    $("#item-" + index).data("item", item);
    $("#item-" + index).data("inventory", "second");

    $("#item-" + index).hover(
      function () {
        OverSetTitleSecond(item.label);
      },
      function () {
        OverSetTitleSecond(" ");
      }
    );

    $("#item-" + index).hover(
      function () {
        if (!!item.metadata && !!item.metadata.description) {
          OverSetDescSecond(item.metadata.description);
        } else {
          OverSetDescSecond(!!item.desc ? item.desc : "");
        }
      },
      function () {
        OverSetDescSecond(" ");
      }
    );
  });
}
