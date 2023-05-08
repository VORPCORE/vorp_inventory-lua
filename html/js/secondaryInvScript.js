function onPromptvalidate(quantity, item) {
    if (!quantity || quantity <= 0 || quantity > 200 || !isInt(quantity)) {
        dialog.close()
        return;
    }
    postData(item, quantity);
}

function postData(itemData, quantity) {
    processEventValidation();
    $.post(`http://vorp_inventory/${itemData.callbackLink}`, JSON.stringify({
        item: itemData,
        type: itemData.type,
        number: quantity,
        id: Id,
        horse: Id,
        store: Id,
        price: itemData.price,
        geninfo: geninfo,
        wagon: Id,
        house: Id,
        hideout: Id,
        bank: Id,
        clan: Id,
        steal: Id,
    }));
}


const types = {
    "custom": ["TakeFromCustom", "MoveToCustom"],
    "horse": ["TakeFromHorse", "MoveToHorse"],
    "cart": ["TakeFromCart", "MoveToCart"],
    "store": ["TakeFromStore", "MoveToStore"],
    "house": ["TakeFromHouse", "MoveToHouse"],
    "hideout": ["TakeFromHideout", "MoveToHideout"],
    "bank": ["TakeFromBank", "MoveToBank"],
    "clan": ["TakeFromClan", "MoveToClan"],
    "steal": ["TakeFromsteal", "MoveTosteal"], // if it weren't for this, this whole Piece of garbage could be entirely systemic...
    "Container": ["TakeFromContainer", "MoveToContainer"],
};
// move sets move or take callbak from unary op;
function onDrop(_, ui, move) {
    itemData = ui.draggable.data("item");
    itemData.callbackLink = types[type][+ move];
    itemInventory = ui.draggable.data("inventory");

    const promptData = {
        title: LANGUAGE.prompttitle,
        button: LANGUAGE.promptaccept,
        required: true,
        item: itemData,
        type: itemData.type,
        input: {
            type: "number",
            autofocus: "true"
        },
        validate: onPromptvalidate
    }

    if ((move === (itemInventory === "second")) || isValidating) return;

    disableInventory(500);

    if (itemData.type === "item_weapon") return postData(itemData, 1);

    dialog.prompt(promptData);
}


function initSecondaryInventoryHandlers() {
    $('#inventoryElement').droppable({
        drop: (event, ui) => onDrop(event, ui, false)
    });

    $('#secondInventoryElement').droppable({
        drop: (event, ui) => onDrop(event, ui, true)
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
                style='background-image: url(\"img/items/${item.name.toLowerCase()}.png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;'
                id="item-${index}" class='item'>
                    ${count > 0 ? `<div class='count'>${count}</div>` : ``}
                    <div class='text'></div>
                </div>
            `)
        } else {
            $("#secondInventoryElement").append("<div data-label='" + item.label +
                "' style='background-image: url(\"img/items/" + item.name.toLowerCase() +
                ".png\"), url(); background-size: 90px 90px, 90px 90px; background-repeat: no-repeat; background-position: center;' id='item-" +
                index + "' class='item'></div></div>")
        }

        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "second");

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