<script>



var width = 250,
    height = 250,
    radius = Math.min(width, height) / 2;


var color = d3.scale.category20();

var arc = d3.svg.arc()
    .outerRadius(radius - 10)
    .innerRadius(radius - 70);

var pie = d3.layout.pie()
    .sort(null)
    .value(function(d) { return d.population; });

var svg = d3.select("section").append("svg")
    .attr("width", width)
    .attr("height", height)
  .append("g")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");



  d3.selectAll("data_selector")
      .on("change", change);

    function change(){
      var value = this.value;
      console.log("value is " + value);
      pie.value(function(d) { return d[value]; });
      path = path.data(pie); // compute the new angles
      path.attr("d", arc);
    }


function pass_data_src(){
var option = document.getElementById("data_selector").value;
console.log("data option" + option);



  if (option == 0) {
    d3.csv("gender.csv", function(error, data) {

      data.forEach(function(d) {
        d.population = +d.population;
      });

      var g = svg.selectAll(".arc")
          .data(pie(data))
        .enter().append("g")
          .attr("class", "arc");

      g.append("path")
          .attr("d", arc)
          .style("fill", function(d) { return color(d.data.gender); });

      g.append("text")
          .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
          .attr("dy", ".35em")
          .style("text-anchor", "middle")
          .text(function(d) { return d.data.gender; });

    });
  }

  if (option == 1) {
      d3.csv("age.csv", function(error, data) {

      data.forEach(function(d) {
        d.population = +d.population;
      });

      var g = svg.selectAll(".arc")
          .data(pie(data))
        .enter().append("g")
          .attr("class", "arc");

      g.append("path")
          .attr("d", arc)
          .style("fill", function(d) { return color(d.data.age); });

      g.append("text")
          .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
          .attr("dy", ".35em")
          .style("text-anchor", "middle")
          .text(function(d) { return d.data.age; });

    });
  }


    if (option == 2) {
      d3.csv("occupation.csv", function(error, data) {

      data.forEach(function(d) {
        d.population = +d.population;
      });

      var g = svg.selectAll(".arc")
          .data(pie(data))
        .enter().append("g")
          .attr("class", "arc");

      g.append("path")
          .attr("d", arc)
          .style("fill", function(d) { return color(d.data.occupation); });

      g.append("text")
          .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
          .attr("dy", ".35em")
          .style("text-anchor", "middle")
          .text(function(d) { return d.data.occupation; });

    });
  }



}

</script>

