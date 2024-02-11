#  Get List Resonse JSON Notes

```
{
  "photos": {
    "page": 1,
    "pages": 5,
    "perpage": 100,
    "total": 500,
    "photo": [
      {
        "id": "53517343677",
        "owner": "137893408@N06",
        "secret": "a66a1d4a0e",
        "server": "65535",
        "farm": 66,
        "title": "Land and water",
        "ispublic": 1,
        "isfriend": 0,
        "isfamily": 0,
        "datetaken": "2023-08-20 08:32:54",
        "datetakengranularity": 0,
        "datetakenunknown": "0",
        "url_z": "https://live.staticflickr.com/65535/53517343677_a66a1d4a0e_z.jpg",
        "height_z": 360,
        "width_z": 640
      },
      {
        "id": "53517269267",
        "owner": "192864031@N07",
        "secret": "e3956a98a9"
        ...
      },
      ...
      ]
   }
   stat: {...},
   extras: {...}
 }
 ```
 
### Top Level

At the top level there are three keys:
```
[
  "extra",
  "photos",  <----
  "stat"
]
```

### Top Level -> Photos key

Under `photos`, there are the following keys:
```
[
  "page",
  "pages",
  "perpage",
  "photo", <----
  "total"
]
```

### Top Level -> Photos -> Photo array

Under `photo`, there is an array of dictionaries (despite the key name is many photos, not just one). Taking one random element as a sample:
```
{
    "id": "53517516683",
    "owner": "9846013@N04",
    "secret": "10db5cb9cc",
    "server": "65535",
    "farm": 66,
    "title": "Candle Light Tour",
    "ispublic": 1,
    "isfriend": 0,
    "isfamily": 0,
    "datetaken": "2024-01-06 19:21:36",
    "datetakengranularity": 0,
    "datetakenunknown": "0",
    "url_z": "https://live.staticflickr.com/65535/53517516683_10db5cb9cc_z.jpg",
    "height_z": 360,
    "width_z": 640
}
```

From here, the only fields we are interested in are `id`, `url_z` and `title`.


