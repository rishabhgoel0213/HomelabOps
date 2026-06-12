#set document(title: "Resume", author: "Rishabh Goel")
#set page(
  paper: "us-letter",
  margin: (x: 0.58in, y: 0.52in),
)
#set text(font: "New Computer Modern", size: 9pt, lang: "en")
#set par(justify: false, leading: 0.54em)

#let accent = rgb("#2f5f7f")

#let section(title) = {
  v(0.55em)
  text(size: 8.5pt, weight: "bold", fill: accent, title)
  v(-0.35em)
  line(length: 100%, stroke: 0.45pt + accent)
  v(0.05em)
}

#let dated(role, date) = {
  block(width: 100%)[#text(weight: "bold", role) #text(size: 8.6pt)[| #date]]
}

#let bullets(items) = {
  v(0.18em)
  for item in items {
    grid(
      columns: (0.18in, 1fr),
      column-gutter: 0.02in,
      text[-],
      item,
    )
    v(0.28em)
  }
}

#align(center)[
  #text(size: 18pt, weight: "bold", tracking: 0.02em)[RISHABH GOEL]

  #v(-0.25em)
  #text(size: 9pt)[
    (571) 919-0109 | #link("mailto:rishabhgoel0213@gmail.com")[rishabhgoel0213\@gmail.com] | #link("https://github.com/rishabhgoel0213")[github.com/rishabhgoel0213]
  ]
]

#v(0.35em)
#text(size: 9.2pt)[
  Physics-minded builder who creates the tools, curricula, and systems I wish existed when I was learning.
]

#section[EDUCATION]

#dated[Rock Ridge High School, Ashburn VA - High School Diploma][Sep 2020 - Jun 2025]
Relevant coursework: AP Physics C: Mechanics, AP Calculus BC, AP Statistics, AP Computer Science A

#v(0.18em)
#dated[University of Maryland, College Park MD - Physics Major][Sep 2025 - May 2029]
Relevant coursework: Introductory Physics: Fields; Introductory Physics: Oscillations and Waves; Experimental Physics I: Mechanics and Waves; Experimental Physics II: Electricity and Magnetism; Multivariable Calculus, Linear Algebra, Differential Equations I and II (Honors); Special Problems in Physics; Object Oriented Programming I and II (exemption exam)

#section[EXPERIENCE & PROJECTS]

#dated[ZeroClone - Open-Source Creator][Apr 2025 - Present]
#bullets((
  [Building a general learning system for two-player perfect-information games, inspired by Google DeepMind's AlphaZero.],
  [Implemented batched-GPU self-play pipeline and plug-and-play game adapters in C++ and Python.],
))

#v(0.05em)
#dated[ResearchTree - Open-Source Creator][May 2026 - Present]
#bullets((
  [Built a framework for turning research ideas into structured search, repeatable experiments, and scored candidate branches.],
  [Added Dockerized workflows for evaluating candidate branches with repeatable scorers and preserved artifacts.],
))

#v(0.05em)
#dated[UMD LHCb Group - Undergraduate Researcher][Dec 2025 - Present]
#bullets((
  [Using bootstrapping methods to estimate uncertainty in one of the trigger mechanisms in the CERN LHC.],
  [Collaborated with graduate students and worked with large datasets using ROOT and similar tools.],
))

#v(0.05em)
#dated[Rock Ridge HS Competitive Programming Club - President][Sep 2021 - Jun 2025]
#bullets((
  [Led and coached 15 members; placed Top-10 in multiple Chesapeake-region university contests.],
  [Built weekly workshops and problem sets to make high-level competitive-programming practice more accessible.],
))

#v(0.05em)
#dated[Yogic Transformers FTC Robotics Team - Autonomous Algorithms Lead][Sep 2021 - Jun 2023]
#bullets((
  [Developed sensor-fusion and vision pipelines for fully autonomous navigation; qualified for state semi-finals twice.],
))

#v(0.05em)
#dated[Quantiphi - Machine Learning Engineer Intern][Jun 2020 - Jul 2020]
#bullets((
  [Prototyped a computer-vision research project under senior mentorship and presented findings to leadership.],
))

#section[SKILLS]

#text(weight: "bold")[Languages:] Python; C++; Java; Bash/Zsh; Embedded C/C++ (Arduino)\
#text(weight: "bold")[AI / ML & Data:] PyTorch; Reinforcement Learning (MCTS, self-play); NumPy/Pandas\
#text(weight: "bold")[Systems & DevOps:] Linux admin; Docker; CMake/build pipelines; Git/GitHub\
#text(weight: "bold")[Math & Science:] Mechanics; Electromagnetism; Probability/Statistics; Calculus\
#text(weight: "bold")[Agentic Coding:] Claude Code; Codex

#section[INTERESTS]

Particle physics, cosmology, deep learning, character-driven literature ("The Goldfinch," "A Little Life," "Pachinko") and cinema ("Whiplash," "The Pianist," "The Shawshank Redemption").
