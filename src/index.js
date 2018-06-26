import './main.css';

import gstins from '../data/gstins.json';

import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

Main.embed(document.getElementById('root'), { gstins });

registerServiceWorker();
