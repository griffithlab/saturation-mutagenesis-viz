// !preview r2d3 data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20)
//
// r2d3: https://rstudio.github.io/r2d3
//

// set the dimensions and margins of the graph, this is adding padding to see the axis in the d3 viewport
var margin = {top: 10, right: 30, bottom: 30, left: 20},
  width = width - margin.left - margin.right,
  height = height - margin.top - margin.bottom;
  
svg.append("g")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

/*
*  Set up variables for x and y axis, we don't actually plot anything here
*  but are defining where things will go
*/

// Build continuosu X scale
var x_values = data.values.map(o => o.score_x);
var x = d3.scaleLinear()
          .domain([d3.min(x_values), d3.max(x_values)])
          .range([ 0, width ]);

// Build continuous Y scale
var y_values = data.values.map(o => o.score_y);
var y = d3.scaleLinear()
          .domain([d3.min(y_values), d3.max(y_values)])
          .range([ height , 0 ]);
  
svg.append("g")
  .call(d3.axisLeft(y));
  
svg.append("g")
  .attr("transform", "translate(0," + height + ")")
  .attr("class", "x-axis")
  .call(d3.axisBottom(x));

// create points
var points = svg.selectAll("circle")
             .data(data.values, function(d, i) { return d.id;});
const t = svg.transition()
             .duration(1000);
             
// enter/update/exit block
points.join(
    enter => enter
         .append("circle")
            .attr("cx", function (d, i) { return x(d.score_x); } )
            .attr("y", -30)
            .attr("r", 3.5)
            .style("fill", "#69b3a2")
            .call(enter => enter.transition(t)
            .attr("cy", function (d, i) { return y(d.score_y); } )),
    update => update
            .style("fill", "#69b3a2")
            .call(enter => enter.transition(t)
            .attr("cx", function (d, i) { return x(d.score_x); } )
            .attr("cy", function (d, i) { return y(d.score_y); } )
            .attr("r", 3.5)),
    exit => exit
            .call(exit => exit.transition(t)
            .attr("cy", 0)
            .remove())
);
    

    
    