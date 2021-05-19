import { FilterType } from './filterType';
import {
  shallowFiltersState,
  parseDataToFilters,
} from './stateUtils';

const rawData = {
  "id":[13,12,11,10,9,8,7,6,2],
  "guid":["e9a0cac2-9016-4b8f-83bf-81c286204ae8","e0e4041e-3ea7-4926-a0dd-757781debe31","e59e9210-ee04-4c35-990a-f124b72b038b","dc541f92-24f8-4c7d-bf5e-146d5313b9dd","abe93e0a-00b8-4a26-90e5-2344415a6915","2417ae52-1179-413e-a42e-3b6b7eada7cb","effd9816-5fc4-46ce-9683-2c1bd05723d0","c1e0e744-4f53-43ea-9d87-a55b672aa311","2152c987-1704-4086-ab48-052d4b7dfa19"],
  "owner_guid":["544ac9ec-4cab-4e37-a615-f949a3b77706","68d4b975-aa29-43b0-a904-4d2f26001d39","68d4b975-aa29-43b0-a904-4d2f26001d39","544ac9ec-4cab-4e37-a615-f949a3b77706","544ac9ec-4cab-4e37-a615-f949a3b77706","544ac9ec-4cab-4e37-a615-f949a3b77706","544ac9ec-4cab-4e37-a615-f949a3b77706","544ac9ec-4cab-4e37-a615-f949a3b77706","544ac9ec-4cab-4e37-a615-f949a3b77706"],
  "app_mode":["static","python-api","python-dash","rmd-static","shiny","unknown","rmd-static","static","rmd-static"],
  "content_category":["pin","","","","","","","plot",""],
  "name":["Static----1617992248356","PY3-stocks-1617310449079","Python-Dash-1617309986384","Param-Repppp-1617225769236","Shiny-App-1617224406672","Python-Dash-1617224345888","RMD-test-1615331957502","Plot-1615331919236","Param-RMD-1613668823058"],
  "title":["Pinned CSV","PY3 stocks","Python Dash","Param Report 2020","Shiny App","Python Dash","RMD One","Plot Twist","Param RMD"],
  "description":["","","","","","","","",""],
  "tags":[
    { name: ["vegetables", "carrot", "vitamin D"] },
    { name: "orange" },
    { name: ["fruits", "orange"] },
    { name: ["nutrition", "vitamin B", "vitamin D"] },
    { name: "watermelon" },
    { name: ["fruits", "strawberry"] },
    { name: ["other", "minerals", "zinc"] },
    { name: ["distros", "alpine"] },
    { name: "minerals" },
  ],
  "url":["https://test.js.io/content/e9a0cac2-9016-4b8f-83bf-81c286204ae8/","https://test.js.io/content/e0e4041e-3ea7-4926-a0dd-757781debe31/","https://test.js.io/content/e59e9210-ee04-4c35-990a-f124b72b038b/","https://test.js.io/content/dc541f92-24f8-4c7d-bf5e-146d5313b9dd/","https://test.js.io/content/abe93e0a-00b8-4a26-90e5-2344415a6915/","https://test.js.io/content/2417ae52-1179-413e-a42e-3b6b7eada7cb/","https://test.js.io/content/effd9816-5fc4-46ce-9683-2c1bd05723d0/","https://test.js.io/content/c1e0e744-4f53-43ea-9d87-a55b672aa311/","https://test.js.io/content/2152c987-1704-4086-ab48-052d4b7dfa19/"],"created_time":["2021-04-09T18:17:28Z","2021-04-01T20:54:09Z","2021-04-01T20:46:26Z","2021-03-31T21:22:49Z","2021-03-31T21:00:06Z","2021-03-31T20:59:05Z","2021-03-09T23:19:17Z","2021-03-09T23:18:39Z","2021-02-18T17:20:23Z"],
  "updated_time":["2021-04-09T18:17:28Z","2021-04-01T20:54:09Z","2021-04-01T20:46:26Z","2021-03-31T21:22:49Z","2021-03-31T21:00:06Z","2021-03-31T20:59:05Z","2021-03-09T23:19:17Z","2021-03-09T23:18:39Z","2021-03-09T17:54:48Z"],
  "owner_username":["jzcarpenter","reporterfrank","automata","reporterfrank","jzcarpenter","reporterfrank","autoreporter009","brucebowtie","brucebowtie"],
  "owner_first_name":["Johannes","Frank","automata","Frank","Johannes","Frank","autoreporter009","Bruce","Bruce"],
  "owner_last_name":["Zigma","Who","","Who","Zigma","Who","","Bowtie","Bowtie"]
}

describe('shallowFiltersState', () => {
  it('returns a shallow Filters state ready to be used', () => {
    const subject = shallowFiltersState();
    expect(subject[FilterType.owner]).toEqual([]);
    expect(subject[FilterType.type]).toEqual([]);
    expect(subject[FilterType.tag]).toEqual([]);
  });
});

describe('parseDataToFilters', () => {
  it('parses data frame raw data to available filter options', () => {
    const result = parseDataToFilters(rawData);
    expect(result[FilterType.owner]).toEqual([
      {
        "applicableRows": [ 3 ],
        "filterType": "owner",
        "index": 0,
        "isSelected": false,
        "label": "automata",
        "name": "automata",
      },
      {
        "applicableRows": [ 7 ],
        "filterType": "owner",
        "index": 1,
        "isSelected": false,
        "label": "autoreporter009",
        "name": "autoreporter009",
      },
      {
        "applicableRows": [ 8, 9 ],
        "filterType": "owner",
        "index": 2,
        "isSelected": false,
        "label": "brucebowtie",
        "name": "brucebowtie",
      },
      {
        "applicableRows": [ 1, 5 ],
        "filterType": "owner",
        "index": 3,
        "isSelected": false,
        "label": "jzcarpenter",
        "name": "jzcarpenter",
      },
      {
        "applicableRows": [ 2, 4, 6 ],
        "filterType": "owner",
        "index": 4,
        "isSelected": false,
        "label": "reporterfrank",
        "name": "reporterfrank",
      },
    ]);
    expect(result[FilterType.type]).toEqual([
      {
        "applicableRows": [ 2 ],
        "filterType": "type",
        "index": 0,
        "isSelected": false,
        "label": "API",
        "name": "API",
      },
      {
        "applicableRows": [ 3, 5 ],
        "filterType": "type",
        "index": 1,
        "isSelected": false,
        "label": "Application",
        "name": "Application",
      },
      {
        "applicableRows": [ 4, 7, 9 ],
        "filterType": "type",
        "index": 2,
        "isSelected": false,
        "label": "Document",
        "name": "Document",
      },
      {
        "applicableRows": [ 6 ],
        "filterType": "type",
        "index": 3,
        "isSelected": false,
        "label": "Other",
        "name": "Other",
      },
      {
        "applicableRows": [ 1 ],
        "filterType": "type",
        "index": 4,
        "isSelected": false,
        "label": "Pin",
        "name": "Pin",
      },
      {
        "applicableRows": [ 8 ],
        "filterType": "type",
        "index": 5,
        "isSelected": false,
        "label": "Plot",
        "name": "Plot",
      },
    ]);
    expect(result[FilterType.tag]).toEqual([
      {
        "applicableRows": [ 8 ],
        "filterType": "tag",
        "index": 0,
        "isSelected": false,
        "label": "alpine",
        "name": "alpine",
      },
      {
        "applicableRows": [ 1 ],
        "filterType": "tag",
        "index": 1,
        "isSelected": false,
        "label": "carrot",
        "name": "carrot",
      },
      {
        "applicableRows": [ 8 ],
        "filterType": "tag",
        "index": 2,
        "isSelected": false,
        "label": "distros",
        "name": "distros",
      },
      {
        "applicableRows": [ 3, 6 ],
        "filterType": "tag",
        "index": 3,
        "isSelected": false,
        "label": "fruits",
        "name": "fruits",
      },
      {
        "applicableRows": [ 7, 9 ],
        "filterType": "tag",
        "index": 4,
        "isSelected": false,
        "label": "minerals",
        "name": "minerals",
      },
      {
        "applicableRows": [ 4 ],
        "filterType": "tag",
        "index": 5,
        "isSelected": false,
        "label": "nutrition",
        "name": "nutrition",
      },
      {
        "applicableRows": [ 2, 3 ],
        "filterType": "tag",
        "index": 6,
        "isSelected": false,
        "label": "orange",
        "name": "orange",
      },
      {
        "applicableRows": [ 7 ],
        "filterType": "tag",
        "index": 7,
        "isSelected": false,
        "label": "other",
        "name": "other",
      },
      {
        "applicableRows": [ 6 ],
        "filterType": "tag",
        "index": 8,
        "isSelected": false,
        "label": "strawberry",
        "name": "strawberry",
      },
      {
        "applicableRows": [ 1 ],
        "filterType": "tag",
        "index": 9,
        "isSelected": false,
        "label": "vegetables",
        "name": "vegetables",
      },
      {
        "applicableRows": [ 4 ],
        "filterType": "tag",
        "index": 10,
        "isSelected": false,
        "label": "vitamin B",
        "name": "vitamin B",
      },
      {
        "applicableRows": [ 1, 4 ],
        "filterType": "tag",
        "index": 11,
        "isSelected": false,
        "label": "vitamin D",
        "name": "vitamin D",
      },
      {
        "applicableRows": [ 5 ],
        "filterType": "tag",
        "index": 12,
        "isSelected": false,
        "label": "watermelon",
        "name": "watermelon",
      },
      {
        "applicableRows": [ 7 ],
        "filterType": "tag",
        "index": 13,
        "isSelected": false,
        "label": "zinc",
        "name": "zinc",
      },
    ]);
  });
});
