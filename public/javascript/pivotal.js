function memberStories(data) {

  var w = 500,
      h = 150;

  var svg = d3.select("#chart")
    .append("svg")
    .attr("width", w)
    .attr("height", h);

  var color = d3.scale.category20();

  var max_n = 0;
  for (var d in data) {
    max_n = Math.max(data[d].story_amount, max_n);
  }

  var dx = w / max_n;
  var dy = h / data.length;

  // bars
  var bars = svg.selectAll(".bar")
    .data(data)
    .enter()
    .append("rect")
    .attr("class", function(d, i) {return "bar " + d.owner_id;})
    .attr("x", function(d, i) {return 0;})
    .attr("y", function(d, i) {return dy*i;})
    .attr("fill", function(d, i) { return color(i); })
    .attr("width", function(d, i) {return dx*d.story_amount})
    .attr("height", dy);

  // labels
  var text = svg.selectAll("text")
    .data(data)
    .enter()
    .append("text")
    .attr("class", function(d, i) {return "owner_id " + d.owner_id;})
    .attr("x", 5)
    .attr("y", function(d, i) {return dy*i + 15;})
    .text( function(d) {return d.owner_id + " (" + d.story_amount  + ")";})
    .attr("font-size", "15px")
    .style("font-weight", "bold");

}

function sortData(data) {

  var newData = { name :"Stories", children : [] },
    levels = ["category","status"];

  // For each data row, loop through the expected levels traversing the output tree
  data.forEach(function(d){
      // Keep this as a reference to the current level
      var depthCursor = newData.children;
      // Go down one level at a time
      levels.forEach(function( property, depth ){

          // Look to see if a branch has already been created
          var index;
          depthCursor.forEach(function(child,i){
              if ( d[property] == child.name ) index = i;
          });
          // Add a branch if it isn't there
          if ( isNaN(index) ) {
              depthCursor.push({ name : d[property], children : []});
              index = depthCursor.length - 1;
          }
          // Now reference the new child array as we go deeper into the tree
          depthCursor = depthCursor[index].children;
          // This is a leaf, so add the last element to the specified branch
          if ( depth === levels.length - 1 ) depthCursor.push({ name : d.name });
      });
  });

  return newData;

}

function drawStoryTree(data, index) {

  newData = sortData(data);

  var margin = {top: 30, right: 20, bottom: 30, left: 20},
    width = 960 - margin.left - margin.right,
    barHeight = 20,
    barWidth = width * .8;

  var i = 0,
      duration = 400,
      root;

  var tree = d3.layout.tree()
      .nodeSize([0, 20]);

  var diagonal = d3.svg.diagonal()
      .projection(function(d) { return [d.y, d.x]; });

  var svg = d3.select("section").append("svg")
      .attr("class", "svg" + index)
      .attr("width", width + margin.left + margin.right)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  root = newData;

  function toggleAll(d) {
    if (d.children) {
      d.children.forEach(toggleAll);
      click(d);
    }
  }

  root.children.forEach(toggleAll);
  update(root);

  function update(source) {

    // Compute the flattened node list. TODO use d3.layout.hierarchy.
    var nodes = tree.nodes(root);

    var text = function(d) { return d.name; };

    var height = Math.max(80, nodes.length * barHeight + margin.top + margin.bottom);

    d3.select("svg.svg" + index).transition()
        .duration(duration)
        .attr("height", height);

    d3.select(self.frameElement).transition()
        .duration(duration)
        .style("height", height + "px");

    // Compute the "layout".
    nodes.forEach(function(n, i) {
      n.x = i * barHeight;
    });

    // Update the nodesâ¦
    var node = svg.selectAll("g.node" + index)
        .data(nodes, function(d) { return d.id || (d.id = ++i); });

    var nodeEnter = node.enter().append("g")
        .attr("class", "node" + index)
        .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
        .style("opacity", 1e-6);

    // Enter any new nodes at the parent's previous position.
    nodeEnter.append("rect")
        .attr("y", -barHeight / 2)
        .attr("height", barHeight )
        .attr("width", barWidth)
        .style("fill", color)
        .on("click", click);


    nodeEnter.append("text")
        .attr("dy", 3.5)
        .attr("dx", 5.5)
        .text(text);

    // Transition nodes to their new position.
    nodeEnter.transition()
        .duration(duration)
        .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })
        .style("opacity", 1);

    node.transition()
        .duration(duration)
        .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })
        .style("opacity", 1)
      .select("rect")
        .style("fill", color);

    // Transition exiting nodes to the parent's new position.
    node.exit().transition()
        .duration(duration)
        .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
        .style("opacity", 1e-6)
        .remove();

    // Update the linksâ¦
    var link = svg.selectAll("path.link" + index)
        .data(tree.links(nodes), function(d) { return d.target.id; });

    // Enter any new links at the parent's previous position.
    link.enter().insert("path", "g")
        .attr("class", "link"+index)
        .attr("d", function(d) {
          var o = {x: source.x0, y: source.y0};
          return diagonal({source: o, target: o});
        })
      .transition()
        .duration(duration)
        .attr("d", diagonal);

    // Transition links to their new position.
    link.transition()
        .duration(duration)
        .attr("d", diagonal);

    // Transition exiting nodes to the parent's new position.
    link.exit().transition()
        .duration(duration)
        .attr("d", function(d) {
          var o = {x: source.x, y: source.y};
          return diagonal({source: o, target: o});
        })
        .remove();

    // Stash the old positions for transition.
    nodes.forEach(function(d) {
      d.x0 = d.x;
      d.y0 = d.y;
    });
  }

  // Toggle children on click.
  function click(d) {
    if (d.children) {
      d._children = d.children;
      d.children = null;
    } else {
      d.children = d._children;
      d._children = null;
    }
    update(d);
  }

  function color(d) {
    return d._children ? "#3182bd" : d.children ? "#c6dbef" : "#fd8d3c";
  }
}
