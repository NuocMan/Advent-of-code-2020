BEGIN {
  COUNTER=0
}

END{
  print COUNTER
}

!/cid/ {
  if (NF == 7)
    COUNTER++
}

{
  if (NF == 8)
    COUNTER++
}
