import { config } from 'dotenv';
import express from 'express';
import axios from 'axios';
import Groq from 'groq-sdk';

config();
const groq = new Groq({ apiKey: process.env.API_KEY });
const app = express();

app.use(express.json()); 

app.listen(3000, () => {
    console.log('Server running on http://localhost:3000');
});

app.get('/models', async (req, res) => {
    try {
        const response = await axios.get('https://api.groq.com/openai/v1/models', {
            headers: {
                Authorization: `Bearer ${process.env.API_KEY}`,
            },
        });
        res.json(response.data);
    } catch (error) {
        console.error('Error fetching data from API:', error.message);
        res.status(500).json({ error: 'Failed to fetch data from API' });
    }
});



app.post('/bot', async (req, res) => {
    try {
        const { message } = req.body; // Obtém o conteúdo do cliente no corpo da requisição
        if (!message) {
            return res.status(400).json({ error: 'Message is required in the request body' });
        }

        const completion = await groq.chat.completions.create({
            messages: [
                {
                    role: 'user',
                    content: message,
                },
            ],
            model: 'deepseek-r1-distill-llama-70b', 
        });

        const botReply = completion.choices[0]?.message?.content;

        if (botReply) {
            res.status(200).json({ reply: botReply });
        } else {
            res.status(500).json({ error: 'No response from the Groq API' });
        }
    } catch (error) {
        console.error('Error creating completion:', error.message);
        res.status(500).json({ error: 'Failed to create completion', details: error.message });
    }
});
