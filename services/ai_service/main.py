import os
from fastapi import FastAPI, UploadFile, File
import google.generativeai as genai
from PyPDF2 import PdfReader
import json
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel('gemini-pro')

@app.post("/analyze-resume")
async def analyze_resume(file: UploadFile = File(...), target_role: str = "Software Engineer"):
    # Read PDF
    reader = PdfReader(file.file)
    resume_text = ""
    for page in reader.pages:
        resume_text += page.extract_text()

    prompt = f"""
    Analyze the following resume for the target role: {target_role}.
    Provide the output in JSON format with the following keys:
    1. skill_match_percentage (number)
    2. extracted_skills (list)
    3. missing_skills (list)
    4. resume_score (number out of 100)
    5. improvement_suggestions (list)
    6. recommended_courses (list)
    7. learning_roadmap (list of milestones)

    Resume Text:
    {resume_text}
    """

    response = model.generate_content(prompt)

    try:
        # Clean the response if it contains markdown formatting
        text = response.text
        if "```json" in text:
            text = text.split("```json")[1].split("```")[0]
        result = json.loads(text)
        return result
    except Exception as e:
        return {
            "error": "Failed to parse AI response",
            "raw_response": response.text,
            "details": str(e)
        }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
