import csv
import json
import random


if __name__ == "__main__":

    final_dict = {}
    shapes = ["POINTY", "BLOCKY", "CHUBBY", "STUBBY"]
    colours = ["RED", "ORANGE", "YELLOW", "GREEN", "BLUE", "PURPLE"]
    rarities = ["COMMON", "RARE", "LEGENDARY"]
    amounts = {"COMMON" : 12, "RARE" : 6, "LEGENDARY": 4}

    path_output = "../assets/data/names_data.json"

    # Create dictionary structure
    for shape in shapes:
        final_dict.update({shape : {}})
        for colour in colours:
            final_dict[shape].update({colour : {}})
            for rarity in rarities:
                final_dict[shape][colour].update({rarity : []})


    # Get names from csv files
    forenames_array = []
    surnames_array = []
    with open('forenames.csv', newline='', encoding="utf8") as csv_forenames:
        spamreader = csv.reader(csv_forenames)
        for row in spamreader:
            name_string = ', '.join(row)
            if len(name_string) >= 3:
                forenames_array.append(', '.join(row))

    with open('surnames.csv', newline='', encoding="utf8") as csv_surnames:
        spamreader = csv.reader(csv_surnames)
        for row in spamreader:
            name_string = ', '.join(row)
            if len(name_string) >= 3:
                surnames_array.append(', '.join(row))


    # Populate dictionary
    names_cache = [] # used to prevent duplicate entries by keeping track

    for shape in final_dict:
        for colour in final_dict[shape]:
            for rarity in final_dict[shape][colour]:
                for x in range(amounts[rarity]):
                    new_name = random.choice(forenames_array) + " " + random.choice(surnames_array)

                    if new_name in names_cache:
                        # Too lazy to do a timeout thingy. Generate again if warning comes up.
                        print("WARNING: Reapeted name encountered!")
                        pass
                    else:
                        final_dict[shape][colour][rarity].append(new_name)
                        names_cache.append(new_name)


    # Output json file
    with open(path_output, 'w', encoding='utf-8') as f:
        json.dump(final_dict, f, ensure_ascii=False, indent=4)
