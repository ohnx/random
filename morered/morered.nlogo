to setup  
  ca            ;; clear the world  
  crt 10        ;; make 10 new turtles  
    setup-chips  
  setup-termites  
end  


to go  
  ask turtles [  
    pick-up-chip  
    find-new-pile  
    drop-off-chip  
  ]  
end  

to draw-polygon   
   pd  
   repeat num-sides  
   [       fd size  
     rt (360 / num-sides)]  
end  

to-report absolute-value [number]  
  ifelse number >= 0  
  [ report number]  
  [report 0 – number]  
end  

ask turtles  
[  
    if (attribute > threshold)  
    [  
    set attribute attribute – 1  
    fd 1  
    ]  
] 

ask turtles  
[  
  ifelse (attribute > threshold)  
  [  
    set attribute attribute – 1  
    set color white  
    rt random-float 360  
    fd 1  
  ][  
    set color red  
    rt random-float 90  
    fd 2  
  ]  
]  

to setup-chips  
  ask patches [ if random-float 100 < density  
    [set pcolor yellow ]]  
end 

to setup-termites  
  create-turtles number  
  ask turtles [set color white  
    setxy random-xcor random-ycor]  
end  

to pick-up-chip  
  while [pcolor != yellow]  
    [explore]  
  set pcolor black  
  set color orange  
end  

to explore  
  fd 1  
  rt random-float 50 – random-float 50  
end  

to find-new-pile  
  while [ pcolor != yellow]  
  [ explore]  
end  

to drop-off-chip  
  while [ pcolor != black]  
    [explore]  
  set pcolor yellow  
  set color white  
  fd 20  
end  
