module Main exposing (..)

import Html exposing (Html, text, div, h1, h3, img)
import Html.Attributes exposing (src)


---- MODEL ----

type alias Gstin =
    { gstin: String, name: String, pan: String}

type alias Model =
    {gstins: List Gstin, selected: Gstin}

initGstin : Gstin
initGstin = 
    { gstin = "", name = "", pan = ""}

initModel : Model
initModel =
    { gstins = [], selected = initGstin }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , h3 [] [ text "Your Elm App is working!" ]
        , h3 [] [ text "Your Elm App is working!" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
