import express from "express";
import { router } from "./router.js";
import cookieParser from 'cookie-parser';

const app = express();

app.use(express.json());
app.use(cookieParser());
app.use("/api", router);

app.listen(3000, () => {
    console.log("App is running");
})
