import { Router } from 'express'
import fs from 'fs';
import path from 'path';
import os from 'os';

const router = Router();


router.post('/signup', (req, res) => {
    const userData = req.body;
    let users; //user.json에 최종 저장됨
    if(!fs.existsSync('user.json')){
        users = [];
        users.push(userData);
    } else{
        const userFile = fs.readFileSync('user.json', 'utf-8');
        users = JSON.parse(userFile);
        
        // 해당 유저가 이미 존재하는지 확인
        const username = userData.username;
        const userExistCheck = users.find( (u) => u.username === username)

        if (userExistCheck){ // 해당 유저가 이미 존재하는 경우
            return res.status(401).send('User already exists');
        } else{ // 해당 유저가 존재하지 않는 경우
            users.push(userData);
        }

    }
    fs.writeFileSync('user.json', JSON.stringify(users));
    res.status(201).send('Signup success');
})

router.post('/login', (req, res) => {
    if(!fs.existsSync('user.json')){
        return res.status(401).send("No User File");
    }
    const username = req.body.username;
    const password = req.body.password;
    const users = JSON.parse(fs.readFileSync('user.json', 'utf-8'));
    const userExistCheck = users.find( (u) => u.username === username && u.password === password);
    if (userExistCheck){
        res.cookie('Log-in', 'valid', {
            maxAge: 60*60*1000
        });
        res.status(200).send('Login Success');
    } else{
        res.status(401).send('Login Failed');
    }
    
})

router.get('/users', (req, res) => {
    if(req.cookies['Log-in'] !== 'valid'){
        return res.status(401).send('Please Login First');
    };
    if(!fs.existsSync('user.json')){
        return res.status(401).send("No User File");
    }
    const users = JSON.parse(fs.readFileSync('user.json', 'utf-8'));
    const noPassword = users.map( ({username, password, email}) => ({username, email}) );
    res.json(noPassword); 
})

router.get('/os', (req, res) => {
    const osInfo = {
        "type": os.type(),
        "hostname": os.hostname(),
        "cpu_num": os.cpus().length,
        "total_mem": `${Math.round(os.totalmem()/1000000)}MB`,
    }
    res.json(osInfo);
})

export { router }