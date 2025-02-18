import { config } from 'dotenv';
import express from 'express';
import axios from 'axios';
import Groq from 'groq-sdk';
import cors from 'cors';  // Importando o pacote CORS

config();
const groq = new Groq({ apiKey: process.env.API_KEY });
const app = express();




app.use(cors());  // Usando o middleware CORS no servidor

app.use(express.json()); // Para processar o corpo das requisições como JSON

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
});app.post('/sugest', async (req, res) => {
    try {
        // Aqui vamos esperar que todo o objeto 'processoDetalhes' seja enviado, e não apenas 'message'
        const processoDetalhes = req.body;
        console.log(processoDetalhes)
        
        if (!processoDetalhes || Object.keys(processoDetalhes).length === 0) {
            return res.status(400).json({ error: 'Detalhes do processo são necessários no corpo da requisição' });
        }

        // Agora, com o 'processoDetalhes' completo, você pode usar a estrutura do seu objeto.
        // Vamos gerar o conteúdo para o modelo com base nos dados enviados.
        const message = `Fornecerei detalhes sobre um processo judicial. Com base nessas informações, identifique e retorne, de forma objetiva e sem comentários adicionais, os três nomes das peças processuais mais pertinentes ao caso, separados por virgula : ${JSON.stringify(processoDetalhes)}`;

        const completion = await groq.chat.completions.create({
            messages: [
                {
                    role: 'user',
                    content: message,
                },
            ],
            model: 'deepseek-r1-distill-llama-70b', 
        });

        const botReply = completion.choices[0].message.content;

        if (botReply) {
            res.status(200).json({ reply: botReply, processoDetalhes: processoDetalhes });
        } else {
            res.status(500).json({ error: 'No response from the Groq API' });
        }
    } catch (error) {
        console.error('Error creating completion:', error.message);
        res.status(500).json({ error: 'Failed to create completion', details: error.message });
    }
});


app.post('/peca', async (req, res) => {
    try {
        const message  = req.body; // Armazena a opção escolhida pelo usuário (tipo de peça), e também os dados do scrape [tudo em json]
        console.log("O escolhido foi "+ JSON.stringify(message,null,2))
        if (!message) {
            return res.status(400).json({ error: 'Message is required in the request body' });
        }

        const completion = await groq.chat.completions.create({
            messages: [
                {
                    role: 'user',
                    content: "Fornecerei a seguir um assunto específico e as informações pertinentes a um processo judicial. Com base nesses dados, elabore uma peça processual de forma completa, fundamentada e objetiva, adotando a abordagem tradicional. Sua resposta deverá conter exclusivamente o texto da peça processual, sem comentários adicionais, preencha os campos da peça de acordo com os dados que ja foram passados. " + message,
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