CATEGORIES = [
    "Food",
    "Transport",
    "Bills",
    "Entertainment",
    "Shopping"
]


def get_categories():
    result = []

    for category in CATEGORIES:
        result.append({"name": category})

    return result


def is_valid_category(category):
    return category in CATEGORIES