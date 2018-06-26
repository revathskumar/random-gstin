module Main exposing (..)

import Html exposing (Html, text, div, h1, h3, img)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Json.Decode
import Task

---- MODEL ----

type alias Flags
    = { gstins: Json.Decode.Value }

type alias Gstin =
    { gstin: String, name: String, pan: Maybe String}

type alias Model =
    {gstins: List Gstin, selected: Maybe Gstin}

initGstin : Gstin
initGstin =
    { gstin = "", name = "", pan = Just ""}

initModel : List Gstin -> Model
initModel gstins =
    { gstins = gstins, selected = Nothing }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        gstinsList = case Json.Decode.decodeValue decodeGstinsList flags.gstins of
            Ok gstins ->
                gstins
            Err err ->
                Debug.crash err
    in
        ( initModel gstinsList, Task.succeed UpdatePan |> Task.perform identity )



---- UPDATE ----


type Msg
    = FindFirst
    | UpdatePan

decodeGstinsList : Json.Decode.Decoder (List Gstin)
decodeGstinsList =
    Json.Decode.list decodeGstin


decodeGstin : Json.Decode.Decoder Gstin
decodeGstin =
    Json.Decode.map3 Gstin
        (Json.Decode.field "gstin" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.maybe (Json.Decode.field "pan" Json.Decode.string))


generatePan : Gstin -> Gstin
generatePan gstin =
    let
        pan = String.slice 2 11 gstin.gstin
    in
        {gstin | pan = Just pan}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FindFirst ->
            ( { model | selected = (List.head model.gstins)}, Cmd.none )
        UpdatePan ->
            let
                gstins = List.map generatePan model.gstins
            in
                ( { model | gstins = gstins}, Cmd.none )



---- VIEW ----

viewPan : Maybe String -> String
viewPan maybePan =
    case maybePan of
        Just pan ->
            pan
        Nothing ->
            ""

viewGstin : Maybe Gstin -> List (Html Msg)
viewGstin selected =
    case selected of
        Just gstin ->
            [ h1 [] [ text gstin.gstin ]
            , h3 [] [ text gstin.name ]
            , h3 [] [ text (viewPan gstin.pan) ]
            ]
        Nothing ->
            [ h1 [] [ text "Nothing is selected" ]

            ]

view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg", onClick FindFirst ] []
        , div [] [text "(Click on the logo to find another)"]
        , div [] (viewGstin model.selected)
        ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
