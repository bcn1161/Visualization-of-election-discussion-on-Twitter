
<!DOCTYPE html>
<meta charset="utf-8">
<meta content='width=device-width, initial-scale=0.9, minimum-scale=0.6, maximum-scale=1.0' name='viewport'>
<title>Tweets</title>
<link rel="stylesheet" type="text/css" href="dc.css"/>
<link href="bootstrap.min.css" rel="stylesheet" type="text/css">

<style type="text/css"></style>
<style>
body{
  font-size: 15px;
}
    h4 span {
      font-size:14px;
      font-family: fantasy;
      }
    h4 {
      font-size:16px;
      font-weight:bold;
      }
    h5 span {
        font-size:14px;
        font-weight:normal;
        }
    h5 {
        font-size:14px;
        }
    h2 {
      float: right;
    }
    h2 span {
      font-size:14px;
      font-weight:normal;
      }
  </style>
</head>

<body>


<div class='container-fluid' style='font: 13px sans-serif;'>
  <div class="dc-tweets-count" style="float: left;">
    <h2>Election on Twitter
      <span>
        <span class="filter-count"></span>
         selected out of
        <span class="total-count"></span>
         tweets |
        <a href="javascript:dc.filterAll(); dc.renderAll();">Reset All</a>
      </span>
    </h2>
  </div>


<div class = 'row'>
  <div class = 'col-md-9 text-center ' id ='us-chart'>
         <h4>Tweet Distribution by State (color: total amount)</h4>
         <a class="reset" href="javascript:usChart.filterAll();dc.redrawAll();" style="display: none;">reset</a>
         <span class="reset" style="display: none;"> | Current filter: <span class="filter"></span></span>

         <div class="clearfix"></div>
     </div>
    <div class = 'col-md-3'>
        <div class = 'row text-center' style = 'float:left' id='candidate-chart'>

            <span>
              <a class="reset"
                href="javascript:candidateChart.filterAll();dc.redrawAll();"
                style="display: none;">
                reset
              </a>
            </span>
            <div class="clearfix"></div>

        </div>
        <div class='row text-left'  id = 'party-chart'>

            <span>
                <a class="reset"
                  href="javascript:partyChart.filterAll();dc.redrawAll();"
                  style="display: none;">
                  reset
                </a>
              </span>
              <div class="clearfix"></div>

          </div>
      </div>

  </div>



<div class='row'>
<div class='col-md-8'>
  <div class = 'row'>
    <div class='col-md-4 text-center'  id='day-of-week-chart'>
      <h4>by Day of Week</h4>
          <span>
            <a class="reset"
              href="javascript:dayOfWeekChart.filterAll();dc.redrawAll();"
              style="display: none;">
              reset
            </a>
          </span>
               <div class="clearfix"></div>
      </div>
    <div class = 'col-md-4 text-center' style = 'float:left' id='hour-chart'>
  <h4>by Hour</h4>
      <span>
        <a class="reset"
          href="javascript:hourChart.filterAll();dc.redrawAll();"
          style="display: none;">
          reset
        </a>
      </span>
           <div class="clearfix"></div>
  </div>
</div>
    <div class = 'row'>
      <div class = 'col-md-8 text-center' id = 'day-chart'>
		<h4>by Day</h4>
        <span>
          <a class="reset"
            href="javascript:dayChart.filterAll();dc.redrawAll();"
            style="display: none;">
            reset
          </a>
        </span>
        <div class="clearfix"></div>
    </div>
  </div>
</div>
<div class = 'col-md-4 text-center' style = 'float:left' id = 'topic-chart'>

            <a class="reset"
              href="javascript:topicChart.filterAll();dc.redrawAll();"
              style="display: none;">
              reset
            </a>
          </span>
          <div class="clearfix"></div>
      </div>
  </div>





  <div class='row'>
	<div class='span12'>
      <table class='table table-hover' id='dc-tweets-table'>
        <thead>
          <tr class='header'>
            <th>date</th>
            <th>candidate</th>
            <th>party</th>
            <th>topic</th>
            <th>text</th>
          </tr>
        </thead>
      </table>
	</div>
  </div>
</div>

<script src="d3.v3.min.js"></script>
<script src="crossfilter.v1.min.js"></script>
<script src="dc.min.js"></script>
<script src='jquery-2.2.3.min.js' type='text/javascript'></script>
<script src="bootstrap.min.js"></script>
<script>

var candidateChart = dc.pieChart('#candidate-chart');
var topicChart = dc.pieChart('#topic-chart');
var partyChart = dc.pieChart('#party-chart');
var dayOfWeekChart = dc.rowChart('#day-of-week-chart');
var hourChart = dc.barChart('#hour-chart');
var tweetsCount = dc.dataCount('.dc-tweets-count');
var tweetsTable = dc.dataTable('#dc-tweets-table');
var dayChart = dc.barChart("#day-chart");
var usChart = dc.geoChoroplethChart("#us-chart");


function remove_bins(source_group) {
    return {
        all:function () {
            return source_group.all().filter(function(p) {
                return p.key != 'NA' && p.key != 'gender';
            });
        }
    };
}




// (It's CSV, but GitHub Pages only gzip's JSON at the moment.)
d3.csv('tweets.json', function (error,tweets) {

  var formatNumber = d3.format(",d"),
      formatChange = d3.format("+,d"),
      formatDate = d3.time.format("%m/%d/%Y"),
      formatTime = d3.time.format("%I:%M %p"),
      numberFormat = d3.format('.2f');


  tweets.forEach(function(d, i) {
        d.index = i;
        d.date = parseDate(d.date);
      });

  // A nest operator, for grouping the tweet list.
  var nestByDate = d3.nest()
      .key(function(d) { return d3.time.day(d.date); });



// A nest operator, for grouping the tweet list.


    function parseDate(d) {
          return new Date(2016,
              d.substring(0, 2) - 1,
              d.substring(2, 4),
              d.substring(4, 6),
              d.substring(6, 8));
        }





    // Create the crossfilter for the relevant dimensions and groups.
    var tweet = crossfilter(tweets),
        all = tweet.groupAll(),
        states = tweet.dimension(function (d) {
            return d["location"];
        }),
        stateTweets = states.group(),
        date = tweet.dimension(function(d) { return d.date; }),
        dates = date.group(d3.time.day),
        hour = tweet.dimension(function(d) { return d.date.getHours() + d.date.getMinutes() / 60; }),
        hours = hour.group(Math.floor),
        text = tweet.dimension(function(d) { return d.text; }),
        candidate = tweet.dimension(function(d) { return d.candidate; }),
        Bycandidate = tweet.dimension(function (d) {
          if (d.candidate == "Clinton") {
          return 'Clinton';
        } else if (d.candidate == "Sanders") {
          return 'Sanders';
        } else if (d.candidate == "Trump") {
          return 'Trump';
        } else {
          return 'Cruz';
        }
      }),
      candidateGroup = Bycandidate.group(),
      party = tweet.dimension(function(d) { return d.partyid; }),
      parties = party.group(),
      topic = tweet.dimension(function(d) { return d.topic; }),
      topics = topic.group(),
      newtopics = remove_bins(topics),
      score = tweet.dimension(function(d) { return d.score; }),
      filtered = tweet.dimension(function(d){
        if (d.topic != "NA"&& d.topic != "gender"){
          return d.topic;}
        }),
        filtered_topics = filtered.group(),
      avgscorebytopic = filtered.group().reduce(
              function (p, v) {
                ++p.count;
                p.total += +v.score;
          	    p.average = d3.round((p.total / p.count), 3)*100;
          	    return p;
          	},

          	function (p,v) {
                --p.count;
          	    p.total -= +v.score;
                p.average = p.count ? d3.round((p.total / p.count),3)*100 : 0;
                return p;
          	},

          	function () {
          	    return {
          	        total: 0,
          	        count: 0,
          	        average: 0,
          	    };
              }
          	),
        dayOfWeek = tweet.dimension(function (d) {
        var day = d.date.getDay();
        var name = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        return day + '.' + name[day];
      }),
      dayOfWeekGroup = dayOfWeek.group();




     d3.json("state.json", function (statesJson) {
       usChart.width(990)
       .height(500)
       .transitionDuration(1000)
       .dimension(states)
       .group(stateTweets)
       .colors(d3.scale.quantize().range(["#fff7fb", "#ece7f2", "#d0d1e6",
       "#a6bddb","#9ED2FF", "#81C5FF", "#6BBAFF", "#51AEFF", "#36A2FF", "#1E96FF", "#0089FF", "#0061B5"]))
        .colorDomain([0, 500])
        .colorCalculator(function (d) { return d ? usChart.colors()(d) : '#ccc'; })
        .overlayGeoJson(statesJson.features, "STATE", function(d) {
                return d.properties.NAME;
            })
        .title(function(d) {
            return 'State: ' + d.key + '\nTotal Tweets: ' + numberFormat(d.value ? d.value : 0);
        });


        candidateChart
          .width(250)
          .height(250)
          .radius(120)
          .innerRadius(30)
          .dimension(Bycandidate)
          .group(candidateGroup)
          .label(function (d) {
                  if (candidateChart.hasFilter() && !candidateChart.hasFilter(d.key)) {
                      return d.key + '(0%)';
                  }
                  var label = d.key;
                  if (all.value()) {
                      label += '(' + Math.floor(d.value / all.value() * 100) + '%)';
                  }
                  return label;
              })
          .renderLabel(true)
          .transitionDuration(500)
              .colors(d3.scale.ordinal().range(['#abd9e9','#fdae61','#2c7bb6','#d7191c']))
          .title(function(d){return d.value;})
          ;

          topicChart
            .width(500)
            .height(500)
            .radius(250)
            .innerRadius(80)
            .dimension(topic)
            .group(newtopics)
            .colors(d3.scale.ordinal().range(['#67001f','#b2182b','#d6604d','#f4a582','#fddbc7','#fee08b',
          '#ffffbf','#ffffff','#e6f598','#abdda4','#66c2a5','#3288bd','#03396c']))
            .label(function (d) {
            if (topicChart.hasFilter() && !topicChart.hasFilter(d.key)) {
                return d.key + '(0%)';
            }
            var label = d.key;
            if (all.value()) {
                label += '(' + Math.floor(d.value / all.value() * 100) + '%)';
            }
            return label;
            })
            .renderLabel(true)
            .transitionDuration(500)
            .legend(dc.legend().x(0).y(0).gap(5));
            ;




            partyChart
              .width(250)
              .height(250)
              .radius(100)
              .innerRadius(0)
              .dimension(party)
              .group(parties)
              .label(function (d) {
                      if (partyChart.hasFilter() && !partyChart.hasFilter(d.key)) {
                          return d.key + '(0%)';
                      }
                      var label = d.key;
                      if (all.value()) {
                          label += '(' + Math.floor(d.value / all.value() * 100) + '%)';
                      }
                      return label;
                  })
              .renderLabel(true)
              .colors(d3.scale.ordinal().range(['#0571b0','#ca0020']))
              .transitionDuration(500)
              .title(function(d){return d.value;})
              ;


          dayOfWeekChart /* dc.rowChart('#day-of-week-chart', 'chartGroup') */
               .width(350)
               .height(150)
               .margins({top: 20, left: 5, right: 20, bottom: 20})
               .group(dayOfWeekGroup)
               .dimension(dayOfWeek).ordinalColors(['#3182bd', '#6baed6', '#9ecae1', '#c6dbef', '#dadaeb'])
               .label(function (d) {
                  return d.key.split('.')[1];
                  })
                .title(function (d) {
                  return d.value;
                   })
               .elasticX(true)
                ;

        hourChart
          .width(400)
          .height(150)
          .margins({top: 10, right: 0, bottom: 20, left: 60})
          .dimension(hour)
          .group(hours)
            .transitionDuration(500)
          .elasticY(true)
          .centerBar(true)
          .filterPrinter(function (filters) {
              var filter = filters[0], s = '';
              s += numberFormat(filter[0]) + '% -> ' + numberFormat(filter[1]) + '%';
              return s;
          })
          .round(dc.round.floor)
          .alwaysUseRounding(true)
          .x(d3.scale.linear()
          .domain([0, 24])
          .rangeRound([0,10*24]))
          ;


           dayChart
              .width(800)
              .height(150)
              .elasticX(true)
              .margins({top: 20, right: 30, bottom: 30, left: 40})
              .gap(0)
              .elasticY(true)
              .centerBar(true)
              .dimension(date)
              .group(dates)
                .transitionDuration(500)
                .elasticY(true)
              .x(d3.time.scale()
              .domain([new Date(2016, 2, 15), new Date(2016, 3, 15)])
              .rangeRound([0, 10 * 90]))
              .filter([new Date(2016, 2, 15), new Date(2016, 3, 15)]);

          tweetsCount /* dc.dataCount('.dc-data-count', 'chartGroup'); */
              .dimension(tweet)
              .group(all);


        tweetsTable
          .width(960).height(800)
          .dimension(date)
            .group(function(d) { return "List of Tweets"
  	       })
          .size(30)
            .columns([
            function(d) { return d.date; },
            function(d) { return d.candidate; },
            function(d) { return d.partyid; },
            function(d) { return d.topic; },
            function(d) { return d.text; }
              ])
            .sortBy(function(d){ return d.date; })
            .order(d3.ascending)
            ;



        dc.renderAll();
        dc.redrawAll();
      });


});
d3.selectAll('#version').text(dc.version);
d3.json('https://api.github.com/repos/dc-js/dc.js/releases/latest', function (error, latestRelease) {
    /*jshint camelcase: false */
    d3.selectAll('#latest').text(latestRelease.tag_name); /* jscs:disable */
});

</script>
