// !preview r2d3 data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20)
//
// r2d3: https://rstudio.github.io/r2d3
//

// set the dimensions and margins of the graph, this is adding padding to see the axis in the d3 viewport
var margin = {top: 30, right: 30, bottom: 30, left: 30},
  width = width - margin.left - margin.right,
  height = height - margin.top - margin.bottom;

/*
*  Set up variables for x and y axis, we don't actually plot anything here
*  but are defining where things will go
*/

// Build categorical X scale
var x = d3.scaleBand()
  .range([ 0, width ])
  .domain(data.axis.aa_mt)
  .padding(0.01);

// Build categorical Y scale
var y = d3.scaleBand()
  .range([ height, 0 ])
  .domain(data.axis.aa_position)
  .padding(0.01);
  
// Build a color scale, we extract the assay score from the data and then
// apply the viridis pallete based on the min/max of the assay
var score = data.values.map(o => o.score).filter(o => !!o);
var myColor = d3.scaleSequential()
  .domain([Math.min(...score), Math.max(...score)]);
switch (options){
  case "viridis" : myColor.interpolator(d3.interpolateViridis);
  break;
  case "plasma" : myColor.interpolator(d3.interpolatePlasma);
  break;
  case "inferno" : myColor.interpolator(d3.interpolateInferno);
  break;
  case "magma" : myColor.interpolator(d3.interpolateMagma);
  break;
  default: myColor.interpolator(d3.interpolateViridis);
}

/*
* Set up the cell tiles for the heatmap using the mutant amino acid for X
* and the position of the amino acid in the transcript for the Y
*/
  // create a tooltip
var tooltip = d3.select('#test')
.append('div')
.attr('id', 'tooltip')
    .style("opacity", 0)
    .attr("class", "tooltip")
    .style("background-color", "white")
    .style("border", "solid")
    .style("border-width", "2px")
    .style("border-radius", "5px")
    .style("padding", "5px");

  // Three function that change the tooltip when user hover / move / leave a cell
  var mouseover = function(d) {
    tooltip.style("opacity", 1)
  }
  var mousemove = function(d) {
    tooltip
      .html("Score" + d.score + "<br>MT:" + d.mt_aa + "<br>AA Position:" + d.position_aa)
      //.style("left", (d3.mouse(this)[0]) + "px")
      //.style("top", (d3.mouse(this)[1]) + "px");
  }
  var mouseleave = function(d) {
    tooltip.style("opacity", 0);
  }
// create tiles with 'rect' elements
var tiles = svg.selectAll('rect')                                               // from our svg select the rectangle elements, important for the enter/update/exit block below
            .data(data.values, function(d) {return d.mt_aa+':'+d.position_aa;}) // bind the data to the rect selection
            
const t = svg.transition()
             .duration(1000);

// set up the enter/update/exit block
tiles.join(
    enter => enter    
        .append("rect")                                                      
        .attr("x", function(d) {return x(d.mt_aa) })                       
        .attr("y", function(d) {return y(d.position_aa) })                  
        .attr("width", x.bandwidth() )                                       
        .attr("height", y.bandwidth() )                                     
        .style("fill", function(d) {return myColor(d.score) })              
        .style("opacity", 0)
        .call(enter => enter.transition(t)
                            .style("opacity", 1)).on("mouseover", mouseover)
   .on("mousemove", mousemove)
   .on("mouseleave", mouseleave),
    update => update                                                  
        .attr("x", function(d) {return x(d.mt_aa) })                      
        .attr("y", function(d) {return y(d.position_aa) })                  
        .attr("width", x.bandwidth() )                                   
        .attr("height", y.bandwidth() )
        .call(update => update.transition(t)
                              .style("fill", function(d) {return myColor(d.score) })),
    exit => exit
            .call( exit => exit.transition(t)
            .style('opacity', 0)
            .remove())
  ).on("mouseover", mouseover)
   .on("mousemove", mousemove)
   .on("mouseleave", mouseleave);
/*  
svg.append('g')
      .call(d3.brush()                     // Add the brush feature using the d3.brush function
      .extent( [ [0,0], [width,height] ] )       // initialise the brush area: start at 0,0 and finishes at width,height: it means I select the whole graph area
      .on("end", update1)
      );
      
function update1() {
    extent = d3.event.selection;
    return tiles.classed("selected", function(d) { 
      return isBrushed(extent, x(d.mt_aa), y(d.position_aa)) });
}

// A function that return TRUE or FALSE according if a dot is in the selection or not
function isBrushed(brush_coords, x, y) {
     var x0 = brush_coords[0][0],
         x1 = brush_coords[1][0],
         y0 = brush_coords[0][1],
         y1 = brush_coords[1][1];
    return x0 <= x && x <= x1 && y0 <= y && y <= y1;    // This return TRUE or FALSE depending on if the points is in the selected area
}
*/
// Draw the axis
svg.selectAll(".x-axis").remove();
svg.append("g")
  .attr("transform", "translate(0," + height + ")")      // This controls the vertical position of the Axis
  .attr("class", "x-axis")
  .call(d3.axisBottom(x));
/*
//svg.append("g")
//  .attr("class", "y-axis")
//  .call(d3.axisLeft(y));

//svg.append("g")
//  .attr("class", "x-axis")
//  .attr("transform", "translate(0," + height + ")")
//  .call(d3.axisBottom(x));

//svg.append("g")
//  .attr("class", "y-axis")
//  .call(d3.axisLeft(y));

//svg.append("g")
//  .attr("class", "x-axis")
//  .attr("transform", "translate(0," + height + ")")
//  .call(d3.axisBottom(x));

// set the dimensions and margins of the graph
var margin = {top: 30, right: 30, bottom: 30, left: 30},
  width = width - margin.left - margin.right,
  height = height - margin.top - margin.bottom;

// svg is a special variable passed by r2d3, save a copy, also wipe previous
// svg elements so data isn't overlayed when changing datasets

// append the svg object to the body of the page
var svg = svg.attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
.append("g")
  .attr("transform",
        "translate(" + margin.left + "," + margin.top + ")");
    


// Build color scale
var score = data.values.map(o => o.score).filter(o => !!o);
var myColor = d3.scaleSequential()
  .domain([Math.min(...score), Math.max(...score)])
  .interpolator(d3.interpolateViridis);

// create a tooltip
var tooltip = d3.select("div")
  .append("div")
  .style("opacity", 0)
  .attr("class", "tooltip")
  .style("background-color", "white")
  .style("border", "solid")
  .style("border-width", "2px")
  .style("border-radius", "5px")
  .style("padding", "5px");

// Three function that change the tooltip when user hover / move / leave a cell
var mouseover = function(d) {
  tooltip.style("opacity", 1)
  .style("top",  (d3.mouse(this)[1]+500) + "px")
  .style("left", (d3.mouse(this)[0]) + "px");
};
var mousemove = function(d) {
  tooltip
    .html("The exact value of<br>this cell is: " + d.score);
};
var mouseleave = function(d) {
  tooltip.style("opacity", 0);
};
    
svg.selectAll()
    .data(data.values, function(d) {return d.mt_aa+':'+d.position_aa;})
    .enter()
    .append("rect")
    .attr("x", function(d) {return x(d.mt_aa) })
    .attr("y", function(d) {return y(d.position_aa) })
    .attr("width", x.bandwidth() )
    .attr("height", y.bandwidth() )
    .style("fill", function(d) {return myColor(d.score) })
    .on("mouseover", mouseover)
    .on("mousemove", mousemove)
    .on("mouseleave", mouseleave);

svg.select("svg").exit().remove();

svg.transition()
    .duration(500);


// Add brushing
//svg.append("g")
//      .attr("class", "brush")
//      .call( d3.brushX()                     // Add the brush feature using the d3.brush function
//        .extent( [ [0,0], [width,height] ] )       // initialise the brush area: start at 0,0 and finishes at width,height: it means I select the whole graph area
//      );

*/

    
    