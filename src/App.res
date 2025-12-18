type factsResponse = {
  facts: array<string>
}

module FactsDecode = {
  let factsResponse = Json.Decode.object(field => {
    facts: field.required(. "facts", Json.Decode.array(Json.Decode.string))
  })
}

@react.component
let make = () => {
  let (facts, setFacts) = React.useState(() => [])

  React.useEffect(() => {
    let request = async () => {
      let response = await Fetch.fetch("https://api.jsongpt.com/json?prompt=Generate%205%20dog%20facts%20&facts=array%20of%20dog%20facts", {})
      let json = await response->Fetch.Response.json
      let facts = (json->Json.decode(FactsDecode.factsResponse)->Result.getOr({facts: []})).facts
      setFacts(_ => facts)
    }
    let _ = request()
    None
  }, [])
  
  <div className="max-w-200">
    {
      facts->Array.map(fact =>
        <span>{fact->React.string}</span> 
      )->React.array
    }
  </div>
}
